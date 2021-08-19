import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/src/screens/home/event_list_page.dart';
import 'package:flutter_chat/src/screens/chat/chat_view.dart';

FirebaseUser loggedInUser;

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final _auth = FirebaseAuth.instance;

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        setState(() {
          loggedInUser = user;
          print(loggedInUser);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    //todo: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('UserData').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print('user==$snapshot');
              final eventsSnapshot = snapshot.data.documents;
              if (eventsSnapshot != null) {
                List<ChatItems> eventList = [];
                for (var eventData in eventsSnapshot) {
                  final uid = eventData.data['userUID'];
                  if (loggedInUser.uid != uid) {
                    final userPic = eventData.data['userPic'];
                    final email = eventData.data['userEmail'];
                    final firstName = eventData.data['userNameFirst'];
                    final lastName = eventData.data['userNameLast'];
                    final userCountry = eventData.data['userCountry'];
                    final uid = eventData.data['userUID'];
                    final userDeviceID = eventData.data['userDeviceID'];
                    print(eventData.documentID);
                    final userData = ChatItems(
                      userID: uid,
                      firstName: firstName,
                      email: email,
                      profilePictureUrl: userPic,
                      lastName: lastName,
                      userDeviceID: userDeviceID,
                      userCountry: userCountry,
                    );
                    eventList.add(userData);
                  }
                }
                return ListView(children: eventList);
              }
              return Container();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

class ChatItems extends StatelessWidget {
  ChatItems(
      {this.userID,
      this.firstName,
      this.profilePictureUrl,
      this.selectAvatar,
      this.email,
      this.lastName,
      this.userDeviceID,
      this.userCountry});

  String userID;
  String firstName;
  String profilePictureUrl;
  String selectAvatar;
  String email;
  String lastName;
  String userDeviceID;
  String userCountry;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatView(
                      receivedId: userID,
                      userDeviceID: userDeviceID,
                    )),
          );
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 5.0),
          child: new Stack(fit: StackFit.loose, children: <Widget>[
            new Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Container(

                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange[100],
                          Colors.orange[100],
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                     ),
                  height: 80.0,
                  width: MediaQuery.of(context).size.width - 80,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        email,
                        style: TextStyle(color: Colors.black, fontSize: 17),
                        textScaleFactor: 1.0,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 30,
                          ),
                          Icon(Icons.person,color:  Colors.brown[500]),
                          Expanded(
                            child: Text(firstName + '\n' + lastName,
                                style: TextStyle(
                                    color: Colors.brown[500],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.language,color:  Colors.brown[500]),
                          Expanded(
                            child: Text(
                              userCountry,
                              style:
                                  TextStyle(color:  Colors.brown[500], fontWeight: FontWeight.bold,fontSize: 12),
                              textScaleFactor: 1.0,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
                padding: EdgeInsets.only(top: 10.0, right: 240.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new CircleAvatar(
                      backgroundColor: Colors.orange.shade900,
                      radius: 40.0,
                      backgroundImage: (profilePictureUrl != null &&
                              !profilePictureUrl.isEmpty)
                          ? NetworkImage(profilePictureUrl)
                          : AssetImage('images/avatar.png'),
                    )
                  ],
                )),
          ]),
        ),
      ),
    );
  }
}
