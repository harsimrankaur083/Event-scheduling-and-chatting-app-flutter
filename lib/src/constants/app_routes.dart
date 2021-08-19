import 'package:flutter/material.dart';
import 'package:flutter_chat/src/screens/event/event_create.dart';

import 'package:flutter_chat/src/screens/forgot_password_page.dart';
import 'package:flutter_chat/src/screens/home/about_page.dart';
import 'package:flutter_chat/src/screens/home/bottom_navigation.dart';
import 'package:flutter_chat/src/screens/home/profile_edit_page.dart';

import 'package:flutter_chat/src/screens/login_page.dart';
import 'package:flutter_chat/src/screens/register_page.dart';
import 'package:flutter_chat/src/screens/slider/welcome_slider.dart';
import 'package:flutter_chat/src/screens/splash_screen.dart';

class AppRoutes {
  final expertRoutes = {
    SplashScreen.routeName: (context) => SplashScreen(),
    LoginPage.routeName: (context) => LoginPage(),
    RegisterPage.routeName: (context) => RegisterPage(),
    ForgotPassword.routeName: (context) => ForgotPassword(),
    BottomNav.routeName: (context) => BottomNav(),
    WelcomeSlider.routeName: (context) => WelcomeSlider(),
    About.routeName: (context) => About(),

    EventEntry.routeName: (context) => EventEntry(),
    EditProfile.routeName: (context) => EditProfile(),
  };

  route(BuildContext, [int mode = 0]) {
    return expertRoutes;
  }

  generateRoutes(RouteSettings settings) {
    final String pathElements = settings.name;
    print('name==${settings.name}');
    print('name==${settings.arguments}');
//    if (pathElements != null) {
//      if (pathElements == '/event/event_view') {
//        return MaterialPageRoute<bool>(
//            builder: (BuildContext context) =>
//                EventView(eventId: settings.arguments));
//      }
//
//      if (pathElements == '/chat_screen') {
//        return MaterialPageRoute<bool>(
//            builder: (BuildContext context) =>
//                ChatScreen(receiverId:settings.arguments));
//      }
//    }
    return null;
  }
}
