import 'package:flutter/material.dart';

import 'MonthlyPage.dart';
import 'TodayPage.dart';
import 'YearlyPage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});



  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  var pageList = [TodayPage(),MonthlyPage(),YearlyPage()];

  int selectedIndex = 0;


  @override
  Widget build(BuildContext context) {

    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/2.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                "assets/44.png",
                width: 190,
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
      body: pageList[selectedIndex],
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 248, 235, 223),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 248, 235, 223),
                  image: DecorationImage(
                    image: AssetImage("assets/6.png"),
                    fit: BoxFit.none,
                  )
              ),
              child: Text("Whisker To Do List",style: TextStyle(color: Colors.pink,fontSize: ekranGenisligi/15,fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: ListTile(
                leading: Image.asset("assets/9.png"),
                title: Text("Daily To Do",style: TextStyle(color: Colors.pink,fontSize:ekranGenisligi/20,fontWeight: FontWeight.bold),),
                onTap: (){
                  setState(() {
                    selectedIndex = 0;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: ListTile(
                leading: Image.asset("assets/8.png"),
                title: Text("Monthly To Do",style: TextStyle(color: Colors.pink,fontSize:ekranGenisligi/20,fontWeight: FontWeight.bold),),
                onTap: (){
                  setState(() {
                    selectedIndex = 1;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: ListTile(
                leading: Image.asset("assets/7.png"),
                title: Text("Yearly To Do",style: TextStyle(color: Colors.pink,fontSize:ekranGenisligi/20,fontWeight: FontWeight.bold),),
                onTap: (){
                  setState(() {
                    selectedIndex = 2;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),

    );
  }
}