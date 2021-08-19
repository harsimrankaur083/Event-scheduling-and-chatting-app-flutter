import 'package:flutter/material.dart';

class MyStyle {
  //1 Style for app theme
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blue,
    brightness: Brightness.light,
  );

  //2 Style for text
  static const TextStyle splashScreenText =
      TextStyle(color: Colors.red, fontSize: 30, fontFamily: 'hero_font');
  static const TextStyle splashScreenText2 =
      TextStyle(color: Colors.lightBlue, fontSize: 16, fontFamily: 'hero_font');

  static const TextStyle titleFont =
  TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'hero_font2',);
  static const TextStyle normalFont =
  TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'hero_font2',);
  static const TextStyle textFieldDefault =
  TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'hero_font2',);

  static const TextStyle normalFontEhiteColor =
  TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'hero_font2',);

  static const TextStyle buttonText =
      TextStyle(color: Colors.white, fontSize: 18);

  static const TextStyle titleText =
      TextStyle(color: Colors.white, fontSize: 26);

  static const TextStyle normalText =
      TextStyle(color: Colors.white, fontSize: 40);

  static const TextStyle bigText = TextStyle(color: Colors.white, fontSize: 60);

//3 Style for button
//4 Style for input text field
}
