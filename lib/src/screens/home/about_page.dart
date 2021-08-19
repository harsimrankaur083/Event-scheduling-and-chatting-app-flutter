import 'package:flutter/material.dart';

class About extends StatefulWidget {
  static const routeName = '/about_page';

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 30),
                Text("MOBIEVENT",
                    style: TextStyle(color: Colors.black, fontSize: 35)),
                SizedBox(
                  height: 40,
                  child: Divider(
                    color: Colors.blue,
                  ),
                  width: 180,
                ),
                SizedBox(height: 10),
                Image(
                  image: AssetImage('images/ic_launcher_round.png'),
                  height: 170,
                  width: 170,
                ),
                SizedBox(height: 20),
                Text("Don't stop make event",
                    style: TextStyle(color: Colors.red, fontSize: 25)),
                SizedBox(height: 10),
                Text(""),
                SizedBox(height: 10),
                Text("App version : v1.0",
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                SizedBox(height: 30),
                Text(
                  "Copyright 2020 © Eminence Technology Pvt.Ltd. All Rights Reserved",
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text("http://eminencetechnology.com",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        decoration: TextDecoration.underline)),
                SizedBox(height: 20),
                Text('This mobile application making in flutter',
                    style: TextStyle(color: Colors.black, fontSize: 12)),
                SizedBox(
                  height: 15,
                  child: Divider(
                    color: Colors.red,
                  ),
                  width: 250,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
