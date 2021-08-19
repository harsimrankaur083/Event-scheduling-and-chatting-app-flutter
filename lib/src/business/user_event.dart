import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/src/model/event.dart';

class LogicEvent {
  Future<bool> addEvent({String uid, Events events}) async {
    bool valueCheck = false;
    if (events != null) {
      print("user ${uid} ${events.eventTitle} added");
      Firestore.instance
          .document("events/$uid")
          .collection("events")
          .add(events.toJson())
          .then((onValue) {
        valueCheck = true;
      }).catchError((onError) {
        print(onError);
      });
    }
    return valueCheck;
  }

  void getEvent() {}

  Future<bool> editEvent({String uid, Events events, String eventid}) async {
    bool valueCheck = false;
    if (events != null) {
      Firestore.instance
          .document("events/$uid")
          .collection("events")
          .document(eventid)
          .updateData(events.toJson())
          .then((onValue) {
        valueCheck = true;
      }).catchError((onError) {
        print(onError);
      });
    }
    return valueCheck;
  }

  void deleteEvent() {}

  void getEventList() {}
}
