import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String userNameFirst;
  final String userNameLast;
  final String userEmail;
  final String userUID;
  final String userPic;
  final String userCountry;
  final String userDeviceID;
  final String bio;
  final String phone;
final String gender;

  User({
    this.userNameFirst,
    this.userNameLast,
    this.userEmail,
    this.userUID,
    this.userPic,
    this.userCountry,
    this.userDeviceID,
    this.bio,
    this.phone,
    this.gender,

  });

  Map<String, Object> toJson() {
    return {
      'userNameFirst': userNameFirst,
      'userNameLast': userNameLast == null ? '' : userNameLast,
      'userEmail': userEmail == null ? '' : userEmail,
      'userUID': userUID == null ? '' : userUID,
      'userCountry': userCountry == null ? '' : userCountry,
      'userDeviceID': userDeviceID == null ? '' : userDeviceID,
      'gender': gender == null ? '' : gender,
    };
  }
  Map<String, Object> toJsonUpdate() {
    return {
      'userNameFirst': userNameFirst,
      'userNameLast': userNameLast == null ? '' : userNameLast,
      'userCountry': userCountry == null ? '' : userCountry,
      'bio': bio == null ? '' : bio,
      'phone': phone == null ? '' : phone,
      'gender': gender == null ? '' : gender,
    };
  }

  Map<String, Object> toProfileJson() {
    return {
      'userPic': userPic == null ? '' : userPic,
    };
  }

 static Map<String, Object> toSaveDeviceID(String deviceID) {
    return {
      'userDeviceID': deviceID == null ? '' : deviceID,
    };
  }
  factory User.fromJson(Map<String, Object> doc) {
    User user = new User(
      userNameFirst: doc['userNameFirst'],
      userNameLast: doc['userNameLast'],
      userUID: doc['userUID'],
      userPic: doc['userPic'],
      userEmail: doc['userEmail'],
      userCountry: doc['userCountry'],
      userDeviceID: doc['userDeviceID'],
      bio: doc['bio'],
      phone: doc['phone'],
      gender: doc['gender'],

    );
    return user;
  }


  factory User.fromDocument(DocumentSnapshot doc) {
    return User.fromJson(doc.data);
  }
}
