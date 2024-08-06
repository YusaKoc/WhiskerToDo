import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/Messagesdao.dart';
import '../classes/classes.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {

  List<int> selectedIds = [];
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
      selectedIds = _prefs.getStringList('selectedIds')?.map((id) => int.tryParse(id) ?? 0).toList() ?? [];
    });
  }

  _saveCheckboxState(int messageId, bool value) async {
    if (value) {
      selectedIds.add(messageId);
    } else {
      selectedIds.remove(messageId);
    }
    _prefs = await SharedPreferences.getInstance();
    _prefs.setStringList('selectedIds', selectedIds.map((id) => id.toString()).toList());
  }

  Future<List<today>> allTodayShow() async {
    var todayList = await Todaydao().allToday();
    return todayList;
  }

  Future<void> addMessageTodayShow(String mesajtoday) async {
    await Todaydao().addMessageToday(mesajtoday);
  }

  Future<void> deleteMessageToday(int mesaj_id) async {
    await Todaydao().deleteMessageToday(mesaj_id);
  }

  Future<void> todayMessageEditor(int mesaj_id, String newMessage) async {
    await Todaydao().messageEditor(mesaj_id, newMessage);
  }

  @override
  Widget build(BuildContext context) {

    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Daily To Do's", style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold, fontSize: ekranGenisligi / 18),),
        backgroundColor: Color.fromARGB(255, 248, 235, 223),
        actions: [
          Row(
            children: [
              Text("Add Task", style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Add Task"),
                          content: TextField(
                            controller: tfMessageController,
                            decoration: InputDecoration(
                              labelText: "Add Task..",
                            ),
                          ),
                          actions: [
                            TextButton(onPressed: () { Navigator.pop(context); }, child: Text("Cancel")),
                            TextButton(
                              child: Text("Add"),
                              onPressed: () {
                                String messageT = tfMessageController.text.trim();
                                if (messageT.isNotEmpty) {
                                  setState(() {
                                    addMessageTodayShow(messageT);
                                    tfMessageController.clear();
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
              ),
            ],
          )
        ],
      ),
      body: FutureBuilder<List<today>>(
        future: allTodayShow(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            var todayList = snapshot.data;
            return ListView.builder(
              itemCount: todayList!.length,
              itemBuilder: (context, index) {
                var message = todayList[index];
                bool isChecked = selectedIds.contains(message.mesaj_id);
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 248, 235, 223),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      title: Text(
                        message.mesajtoday,
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
                              selectedIds.add(message.mesaj_id);
                            } else {
                              selectedIds.remove(message.mesaj_id);
                            }
                            _saveCheckboxState(message.mesaj_id, newValue);
                          });
                        },
                        value: selectedIds.contains(message.mesaj_id),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: () {
                          setState(() {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Actions"),
                                    content: SizedBox(
                                      height: 50,
                                      child: Center(
                                        child: Text(
                                          "${message.mesajtoday}",
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(onPressed: () { Navigator.pop(context); }, child: Text("Cancel")),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            deleteMessageToday(message.mesaj_id);
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Text("Delete Task"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          tfEditMessageController.text = message.mesajtoday;
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
                                                            todayMessageEditor(message.mesaj_id, newMessage);
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
                        "Plan Your Day",
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
