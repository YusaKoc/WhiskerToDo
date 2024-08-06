import 'dart:async';
import 'package:flutter/material.dart';
import 'MainPage.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;
  int _countdown = 2;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _timer.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainPage(title: "To do List")),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/2.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
          Center(child: Image.asset("assets/44.png"))
        ],
      )
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

