import 'dart:async';
import 'package:drive/home/homePage.dart';
import 'package:drive/logIn/setProfile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreen2 extends StatefulWidget {
  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<LoadingScreen2> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 5), () async {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const SetProfile()));

      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('setProfile') == true) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const MyHomePage()));
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const SetProfile()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Image(
                        width: 150,
                        image: AssetImage('lib/images/logo.png'),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
