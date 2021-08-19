import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/src/business/shared_preference_data.dart';
import 'package:flutter_chat/src/business/user_auto.dart';
import 'package:flutter_chat/src/screens/home/bottom_navigation.dart';
import 'package:flutter_chat/src/screens/login_page.dart';
import 'package:flutter_chat/src/screens/slider/welcome_slider.dart';
import 'dart:async';
import 'event/event_create.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var user;
  bool checkBool;

  void initState() {
    super.initState();
    getCurrentUser();
    startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, selectPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[

            Container(
                color: Colors.black,
                alignment: Alignment.center,
                width: 150,
                height: 150,
                child: Image(image: AssetImage("images/ic_launcher_round.png"),)),
            Container(
              child: Text(
                'MobiEvent',
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
            ),

            Container(
              child: Text(
                'Create EventNote',
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),


    );
  }

  void navigationPageLogin() {
    Navigator.pushReplacementNamed(context, LoginPage.routeName);
  }

  void navigationPageHome() {
    Navigator.pushReplacementNamed(context, BottomNav.routeName);
  }

  void navigationWelcomeSlider() {
    Navigator.pushReplacementNamed(context, WelcomeSlider.routeName);
  }

  void selectPage() async {
    SharedPreferenceData.getBoolFirstScreenSee().then((value) {
      if(value) {
        try {
          Auth.getCurrentFirebaseUser().then((value) {
            if (value != null) {
              setState(() {
                loggedInUser = value;
                if (loggedInUser != null) {
                  navigationPageHome();
                } else {
                  navigationPageLogin();
                }
              });
            }else{
              navigationPageLogin();
            }
          });
        } catch (e) {
          print(e);
        }
      }
      else{
        Navigator.pushReplacementNamed(context, WelcomeSlider.routeName);
      }
    });


  }

  void getCurrentUser() async {
    try {
      user = await SharedPreferenceData.getUserUID();
      if (user != null) {
        setState(() {
          print(user);
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
