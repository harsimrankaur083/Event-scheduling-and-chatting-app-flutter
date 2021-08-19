import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/src/screens/event/event_create.dart';
import 'package:flutter_chat/src/screens/event/event_edit.dart';
import 'package:flutter_chat/src/utils/my_utils.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

FirebaseUser loggedInUser;

class EventListPage extends StatefulWidget {
  String eventId;
  String eventID;

  String userId;
  EventListPage({this.eventId,this.userId,this.eventID});

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventListPage> {
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
    getCurrentUser();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, EventEntry.routeName);
          },
          backgroundColor: Colors.orange[900],
          elevation: 0.2,
          child: Icon(Icons.add),
        ),
        body: Center(
          child: Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('events')
                  .document(loggedInUser.uid)
                  .collection("events")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print('user==$snapshot');
                  final eventsSnapshot = snapshot.data.documents;
                  List<EventItems> eventsList = [];
                  for (var eventData in eventsSnapshot) {
                    final title = eventData.data['eventName'];
                    final desc = eventData.data['desc'];
                    final date = eventData.data['date'];
                    final time = eventData.data['time'];

                    final eventModel = EventItems(
                      title: title,
                      desc: desc,
                      date: date,
                      time: time,
                      eventId: eventData.documentID,
                      userId: loggedInUser.uid,
                    );
                    eventsList.add(eventModel);
                  }
                  return ListView(children: eventsList);
                }
                return Container();
              },
            ),
          ),
        ));
  }
}

class EventItems extends StatelessWidget {
  EventItems(
      {this.title,
      this.desc,
      this.date,
      this.time,
      this.eventId,
      this.eventID,
      this.userId});

  String title;
  String desc;
  String date;
  String eventId;
  String time;

  String eventID, userId;
  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange[800],
                Colors.orange[300],
              ],
            ),
            boxShadow: [
              BoxShadow(

                  color: Colors.black,
                  spreadRadius: 0.5,
                 )
            ]),
        child: ListTile(

          contentPadding: EdgeInsets.all(0.0),
          leading: CircleAvatar(
            radius: 40.0,
            backgroundColor: Colors.black,
            child: Text(
              time,
              style: TextStyle(fontSize: 12.0),
              textScaleFactor: 1.0,
            ),
            foregroundColor: Colors.white,
          ),
          title: Text(
            title + '\n On' + date,
            style: TextStyle(fontSize: 20.0),
            textScaleFactor: 1.0,
          ),
          subtitle: Text(
            desc,
            textScaleFactor: 1.0,
          ),
        ),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: Colors.black,
          icon: Icons.edit,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EventEdit(eventID: eventId, userId: loggedInUser.uid))),
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap:
              () async {
            await _deleteEvent(context,
                userId, eventId).then((onValue) {
              MyUtils.toastMessage("Event Deleted");

            });
            print("error");


          },
        ),
      ],
    );
  }

  _deleteEvent(BuildContext context, String uid, String eventid) {
    Firestore.instance
        .document("events/$uid")
        .collection("events")
        .document(eventid)
        .delete();
  }
}
