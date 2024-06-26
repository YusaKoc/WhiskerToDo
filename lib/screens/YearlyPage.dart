import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whiskertodolist/classes/Messagesdao.dart';
import 'package:whiskertodolist/classes/classes.dart';

class YearlyPage extends StatefulWidget {
  const YearlyPage({super.key});

  @override
  State<YearlyPage> createState() => _YearlyPageState();
}

class _YearlyPageState extends State<YearlyPage> {

  List<int> selectedIds3 = [];
  var tfMessageController = TextEditingController();

  late SharedPreferences _prefs;
  late bool isChecked = false;

  @override
  void initState() {
    super.initState();
    _loadCheckboxState();
  }


  _loadCheckboxState() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      isChecked = _prefs.getBool('isChecked') ?? false;
      selectedIds3 = _prefs.getStringList('selectedIds3')?.map((id) => int.tryParse(id) ?? 0).toList() ?? [];
    });
  }


  _saveCheckboxState(int messageId, bool value) async {
    if (value) {
      selectedIds3.add(messageId);
    } else {
      selectedIds3.remove(messageId);
    }
    _prefs = await SharedPreferences.getInstance();
    _prefs.setStringList('selectedIds3', selectedIds3.map((id) => id.toString()).toList());
  }


  Future<List<yearly>> allYearlyShow() async {
    var yearList = await Yeardao().allYear();
    return yearList;
  }

  Future<void> addMessageYearShow(String yearly_mesaj) async {
    await Yeardao().addMessageYear(yearly_mesaj);

  }
  Future<void> deleteMessageYear(int yearly_id) async {
    await Yeardao().deleteMessageYearly(yearly_id);
  }

  @override
  Widget build(BuildContext context) {

    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;

    return Scaffold(
      appBar: AppBar(
        title: Align(alignment:Alignment(0.2,0),child: Text("Yearly To Do's",style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold,fontSize: ekranGenisligi/18),)),
        backgroundColor: Color.fromARGB(255, 248, 235, 223),
        flexibleSpace: Container(
          child: Align(
            alignment: Alignment(-1.5,0),
            child: Image.asset(
              "assets/7.png",
              width: 190,
              height: 80,
              fit: BoxFit.contain,
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              Text("Add Task",style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold),),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: (){
                  showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: Text("Add Task"),
                          content: TextField(
                            controller: tfMessageController,
                            decoration: InputDecoration(
                              labelText: "Add Task..",
                            ),
                          ),
                          actions: [
                            TextButton(onPressed: (){Navigator.pop(context);}, child: Text("Cancel")),
                            TextButton(
                              child: Text("Add"),
                              onPressed: (){
                                String messageT = tfMessageController.text.trim();
                                if(messageT.isNotEmpty){
                                  setState(() {
                                    addMessageYearShow(messageT);
                                    tfMessageController.clear();
                                    Navigator.pop(context);
                                  });
                                }else{
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context){
                                        return AlertDialog(
                                          title: Text("Warning"),
                                          content: Text("Please enter a task"),
                                          actions: [
                                            TextButton(onPressed: (){Navigator.pop(context);}, child: Text("OK")),
                                          ],
                                        );
                                      }
                                  );
                                }
                              },
                            ),
                          ],
                        );
                      }
                  );
                },
              ),
            ],
          )
        ],
      ),
      body: FutureBuilder<List<yearly>>(
        future: allYearlyShow(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            var yearList = snapshot.data;
            return ListView.builder(
              itemCount: yearList!.length,
              itemBuilder: (context, index) {
                var message = yearList[index];
                bool isChecked = selectedIds3.contains(message.yearly_id);
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 248, 235, 223),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      title: Text(
                        message.yearly_mesaj,
                        style: TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.bold,
                          decoration: isChecked ? TextDecoration.lineThrough : TextDecoration.none,
                        ),
                      ),
                      leading: Checkbox(
                        onChanged: (newValue) {
                          setState(() {
                            if (newValue!) {
                              selectedIds3.add(message.yearly_id);
                            } else {
                              selectedIds3.remove(message.yearly_id);
                            }
                            _saveCheckboxState(message.yearly_id, newValue);
                          });
                        },
                        value: selectedIds3.contains(message.yearly_id),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: () {
                          setState(() {
                            showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    title: Text("Actions"),
                                    content: SizedBox(
                                      height: 50,
                                      child: Center(
                                        child: Text(
                                          "${message.yearly_mesaj}",
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(onPressed: (){Navigator.pop(context);}, child: Text("Cancel")),
                                      TextButton(
                                        onPressed: (){
                                          setState(() {
                                            deleteMessageYear(message.yearly_id);
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Text("Delete Task"),
                                      ),
                                    ],
                                  );
                                }
                            );
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    children: [
                      Image.asset("assets/5.png"),
                      Text(
                        "Plan Your Year",
                        style: TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
