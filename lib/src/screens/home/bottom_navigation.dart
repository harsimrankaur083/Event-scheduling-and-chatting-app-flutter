import 'package:flutter/material.dart';
import 'package:flutter_chat/src/business/shared_preference_data.dart';
import 'package:flutter_chat/src/business/user_auto.dart';
import 'package:flutter_chat/src/screens/home/about_page.dart';
import 'package:flutter_chat/src/screens/home/event_list_page.dart';
import 'package:flutter_chat/src/screens/home/user_list.dart';
import 'package:flutter_chat/src/screens/home/profile_view.dart';
import 'package:flutter_chat/src/screens/login_page.dart';

class BottomNav extends StatefulWidget {
  static const routeName = '/home_bottom_page';

  @override
  _BottomNAvState createState() => _BottomNAvState();
}

class _BottomNAvState extends State<BottomNav> {
  int _currentIndex = 0;
  var userUID;
  var userDEVICEID;
  final List<Widget> _children = [
    EventListPage(),
    UserList(),
    ProfileView(),
  ];
  static List<CustomPopupMenu> choices = <CustomPopupMenu>[
    CustomPopupMenu(title: 'About', icon: Icons.home),
    CustomPopupMenu(title: 'Logout', icon: Icons.bookmark),
  ];

  CustomPopupMenu _selectedChoices = choices[0];
  String title = "Home";

  void _select(CustomPopupMenu choice) {
    setState(() {
      _selectedChoices = choice;
    });

    if (_selectedChoices.title == 'About') {
      print("Profile");
      Navigator.pushNamed(context, About.routeName);
    }
    if (_selectedChoices.title == 'Logout') {
      print("Logout");
      Auth.signOut();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          LoginPage()), (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    sendDeviceID();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.orange[900],
        actions: <Widget>[
          PopupMenuButton<CustomPopupMenu>(
            elevation: 3.2,
//            initialValue: choices[1],
            onCanceled: () {
              print('You have not chossed anything');
            },
            tooltip: 'This is tooltip',
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return choices.map((CustomPopupMenu choice) {
                return PopupMenuItem<CustomPopupMenu>(
                  value: choice,
                  child: Text(choice.title),
                );
              }).toList();
            },
          )
        ],
      ),
      body: _children[_currentIndex], //

      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(
              Icons.home,
              color: Colors.orange[900],
            ),
            title: Text('Event'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            activeIcon: Icon(
              Icons.mail,
              color: Colors.orange[900],
            ),
            title: Text('Users'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.person),
              activeIcon: Icon(
                Icons.person,
                color: Colors.orange[900],
              ),
              title: Text('Profile'))
        ],
      ),
    );
  }

  sendDeviceID() async {
     userUID = await SharedPreferenceData.getUserUID();
     userDEVICEID = await SharedPreferenceData.getDeviceID();
    if (userUID != null) {
      setState(() {
        print('ggi' + userUID);
        print('ggi' + userDEVICEID);
        Auth.sendDeviceID(userUID, userDEVICEID);
      });
    }
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      title = 'Event';
    } else if (index == 1) {
      title = 'Users';
    } else if (index == 2) {
      title = 'Profile';
    }
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}

class CustomPopupMenu {
  CustomPopupMenu({this.title, this.icon, this.onPressed});
  Function onPressed;
  String title;
  IconData icon;
}
