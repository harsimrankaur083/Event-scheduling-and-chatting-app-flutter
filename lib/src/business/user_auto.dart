import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat/src/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError, UnknownError }

class Auth {
  static Future<AuthResult> signIn(String email, String password) async {
    AuthResult user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return user;
  }

  static Future<String> signUp(String email, String password) async {
    AuthResult user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return user.user.uid;
  }

  static Future<void> saveDeviceID(String deviceID, String userUID) async {}

  static Future<bool> deleteDeviceID(String deviceID, String userUID) async {
    bool setValue = false;
    return setValue;
  }

  static Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  static Future<void> signOut() async {
    return FirebaseAuth.instance.signOut();
  }

  static Future<FirebaseUser> getCurrentFirebaseUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }



  static void addUser(User user) async {
    checkUserExist(user.userUID).then((value) {
      if (!value) {
        print("user ${user.userNameFirst} ${user.userEmail} added");
        Firestore.instance
            .document("UserData/${user.userUID}")
            .setData(user.toJson());
      } else {
        print("user ${user.userNameFirst} ${user.userEmail} exists");
      }
    });
  }

  static Future<bool> addUpdateProfile(User user) async {
    bool exists = false;
    Firestore.instance
        .document("UserData/${user.userUID}")
        .updateData(user.toJsonUpdate())
        .then((onValue) {
      exists = true;
    });
    return exists;
  }





  static void updateProfilePic(User user) async {
    Firestore.instance
        .document("UserData/${user.userUID}")
        .updateData(user.toProfileJson());
  }

  static void sendDeviceID(String userID,String deviceID){
    print('uuuu'+userID);
    Firestore.instance
        .document("UserData/${userID}")
        .updateData(User.toSaveDeviceID(deviceID));
  }

  static Future<bool> checkUserExist(String userID) async {
    bool exists = false;
    try {
      await Firestore.instance.document("users/$userID").get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  static Stream<User> getUser(String userID) {
    return Firestore.instance
        .collection("UserData")
        .where("userUID", isEqualTo: userID)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.documents.map((doc) {
        return User.fromDocument(doc);
      }).first;
    });
  }

  static String getExceptionText(Exception e) {
    if (e is PlatformException) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          return 'User with this e-mail not found.';
          break;
        case 'The password is invalid or the user does not have a password.':
          return 'Invalid password.';
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          return 'No internet connection.';
          break;
        case 'The email address is already in use by another account.':
          return 'Email address is already taken.';
          break;
        default:
          return 'Unknown error occured.';
      }
    } else {
      return 'Unknown error occured.';
    }
  }






//  static Future<String> addDeviceID(String userID,String deviceID) async {
//    bool exists = false;
//    Firestore.instance
//        .document("users/${userID}")
//        .updateData(Auth.)
//        .then((onValue) {
//      exists = true;
//    });
//    return exists;
//  }
}
