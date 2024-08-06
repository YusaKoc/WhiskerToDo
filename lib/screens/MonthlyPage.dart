import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whiskertodolist/classes/Messagesdao.dart';
import 'package:whiskertodolist/classes/classes.dart';

class MonthlyPage extends StatefulWidget {
  const MonthlyPage({super.key});

  @override
  State<MonthlyPage> createState() => _MonthlyPageState();
}

class _MonthlyPageState extends State<MonthlyPage> {

  List<int> selectedIds2 = [];
  var tfMessageController = TextEditingController();
  var tfEditMessageController = TextEditingController();

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
      selectedIds2 = _prefs.getStringList('selectedIds2')?.map((id) => int.tryParse(id) ?? 0).toList() ?? [];
    });
  }


  _saveCheckboxState(int messageId, bool value) async {
    if (value) {
      selectedIds2.add(messageId);
    } else {
      selectedIds2.remove(messageId);
    }
    _prefs = await SharedPreferences.getInstance();
    _prefs.setStringList('selectedIds2', selectedIds2.map((id) => id.toString()).toList());
  }


  Future<List<monthly>> allMonthlyShow() async {
    var monthList = await Monthdao().allMonth();
    return monthList;
  }

  Future<void> addMessageMonthShow(String monthlymesaj) async {
    await Monthdao().addMessageMonth(monthlymesaj);

  }
  Future<void> deleteMessageMonth(int monthly_id) async {
    await Monthdao().deleteMessageMonthly(monthly_id);
  }

  Future<void> monthMessageEditor(int monthly_id, String newMessage) async {
    await Monthdao().messageEditor(monthly_id, newMessage);
  }

  @override
  Widget build(BuildContext context) {

    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Month To Do's",style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold,fontSize: ekranGenisligi/18),),
        backgroundColor: Color.fromARGB(255, 248, 235, 223),
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
                                    addMessageMonthShow(messageT);
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
      body: FutureBuilder<List<monthly>>(
        future: allMonthlyShow(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            var monthList = snapshot.data;
            return ListView.builder(
              itemCount: monthList!.length,
              itemBuilder: (context, index) {
                var message = monthList[index];
                bool isChecked = selectedIds2.contains(message.monthly_id);
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 248, 235, 223),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      title: Text(
                        message.monthlymesaj,
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
                              selectedIds2.add(message.monthly_id);
                            } else {
                              selectedIds2.remove(message.monthly_id);
                            }
                            _saveCheckboxState(message.monthly_id, newValue);
                          });
                        },
                        value: selectedIds2.contains(message.monthly_id),
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
                                          "${message.monthlymesaj}",
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(onPressed: (){Navigator.pop(context);}, child: Text("Cancel")),
                                      TextButton(
                                        onPressed: (){
                                          setState(() {
                                            deleteMessageMonth(message.monthly_id);
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Text("Delete Task"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          tfEditMessageController.text = message.monthlymesaj;
                                          Navigator.pop(context);
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Edit Task"),
                                                  content: TextField(
                                                    controller: tfEditMessageController,
                                                    decoration: InputDecoration(
                                                      labelText: "Edit Task..",
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(onPressed: () { Navigator.pop(context); }, child: Text("Cancel")),
                                                    TextButton(
                                                      child: Text("Save"),
                                                      onPressed: () {
                                                        String newMessage = tfEditMessageController.text.trim();
                                                        if (newMessage.isNotEmpty) {
                                                          setState(() {
                                                            monthMessageEditor(message.monthly_id, newMessage);
                                                            Navigator.pop(context);
                                                          });
                                                        } else {
                                                          showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                  title: Text("Warning"),
                                                                  content: Text("Please enter a task"),
                                                                  actions: [
                                                                    TextButton(onPressed: () { Navigator.pop(context); }, child: Text("OK")),
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
                                        child: Text("Edit Task"),
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
                        "Plan Your Month",
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
