import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat/src/constants/app_routes.dart';
import 'package:flutter_chat/src/notification/MessagingWidget.dart';
import 'package:flutter_chat/src/notification/get_device_uniqueId.dart';
import 'package:flutter_chat/src/screens/error_screen.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final appRoutes = AppRoutes();

  @override
  void initState() {
    MessagingWidget.setUP();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      routes: appRoutes.route(context),
      onGenerateRoute: (RouteSettings settings) {
        return appRoutes.generateRoutes(settings);
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (context) => NotFoundScreen());
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
