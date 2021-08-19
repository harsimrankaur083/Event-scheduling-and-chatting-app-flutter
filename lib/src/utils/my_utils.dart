import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyUtils {
  //finish screen
  static void finishScreen(BuildContext context) {
    Navigator.pop(context);
  }

// check url link
  static bool checkValidURL(String url) {
    bool setValue = false;
    if (url != null) {
      setValue = Uri.parse(url).isAbsolute;
    }
    return setValue;
  }

// upload Profile Pic
  Future<String> uploadProfilePicture(String imageName, File image) async {
    final StorageReference ref =
        FirebaseStorage.instance.ref().child('$imageName.jpg');
    final StorageUploadTask uploadTask = ref.putFile(image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    if (downloadUrl.toString() != null) {
      print(downloadUrl);
    } else {}
    return downloadUrl;
  }

// keyBord Down
  static void keyBordDown(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static String openCalenderPicker() {
    DateTime selectDate = DateTime.now();
    Future<Null> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now().subtract(Duration(days: 1)),
          lastDate: DateTime.now().add(
            Duration(days: 1095),
          ));

      if (picked != null && picked != selectDate) {
        selectDate = picked;
      }
    }

    return selectDate.toString();
  }

  static String openTimePicker() {}

  static void showToastNormal(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14.0);
  }
  static void toastMessage(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,

        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
