import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/src/business/shared_preference_data.dart';

import 'package:flutter_chat/src/model/message.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MessagingWidget {
  int _counter = 0;
  static FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

//  static List<Message> messages = [];
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  static void setUP() async{
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');

//    var initializationSettingsIOS = new IOSInitializationSettings(
//        onDidReceiveLocalNotification: onDidRecieveLocalNotification);

    var initializationSettings =
        new InitializationSettings(initializationSettingsAndroid, null);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message ${message}');
        // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
      //  displayNotification(message);
        // _showItemDialog(message);
        return;
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
        displayNotification(message);
        return;
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
        displayNotification(message);
        return;
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) async {
      assert(token != null);
      print('devideID' + token);
    await SharedPreferenceData.setDeviceID(token);
    });
  }

  static Future displayNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'channelid', 'flutterfcm', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message['notification']['title'],
      message['notification']['body'],
      platformChannelSpecifics,
      payload: 'hello',
    );
  }

  static Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Fluttertoast.showToast(
        msg: "Notification Clicked",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
    /*Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new SecondScreen(payload)),
    );*/
  }
}
