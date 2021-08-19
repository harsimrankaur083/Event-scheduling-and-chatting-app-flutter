import 'dart:convert';

import 'package:http/http.dart';

class SendNotification {
  static Future<bool>sendFcmMessage(String title, String message,String receiverDeviceID) async {
    print('hhh'+title);
    print('hhh'+message);
    print('hhh'+receiverDeviceID);
    try {
      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        "Authorization": "key="+"AAAAXHn7030:APA91bHtxq4IZb-f3Q5VFG8sHX9QjZuNG2TqMrbeEer2vQjTg989eYHOI96gmds4tTEWpOpm0uHscm3kkb2oAh3EGaG_bir-H95y63yFD14B_fBe8xrPZXIdFpmUm0eUerLlMwpeYUSa",
      };
//      var request = {
//        "notification": {
//          "title": title,
//          "text": message,
//          "sound": "default",
//          "color": "#990000",
//        },
//        "priority": "high",
//        "to": receiverDeviceID,
//      };
   var   request = {
        'notification': {'title': title, 'body': message},
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'type': 'COMMENT'
        },
        'to': receiverDeviceID
      };
      print("message"+request.toString());
      var client = new Client();
      var response =
          await client.post(url, headers: header, body: json.encode(request));
      print("message"+response.body);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
