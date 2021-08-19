import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat/src/business/shared_preference_data.dart';
import 'package:flutter_chat/src/business/user_auto.dart';
import 'package:flutter_chat/src/constants/app_validation.dart';
import 'package:flutter_chat/src/model/user.dart';
import 'package:flutter_chat/src/screens/home/bottom_navigation.dart';
import 'package:flutter_chat/src/utils/my_utils.dart';
import 'package:flutter_chat/src/widgets/custom_alert_dialog.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = '/register';

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  File _image;
  bool _blackVisible = false;
  String password;
  String email;
  String firstName;
  String lastName;
  String confirmPassword;
  String selectCountry;
  final TextEditingController _typeAheadController = TextEditingController();
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  final auth = FirebaseAuth.instance;

  bool showSpinner = false;
  static final List<String> cities = [
    'Australia',
    'Brazil',
    'Russia',
    'Canada',
    'China',
    'India',
    'United States',
    'Sudan',
  ];

  filterList(List<String> arr, String pattern) {
    if (pattern.length > 0) {
      if (pattern == '' || pattern == null) {
        return arr;
      } else {
        return arr
            .where((String val) =>
                val.toLowerCase().contains(pattern.toLowerCase()))
            .toList();
      }
    }
  }

  Future _selectProfilePicture() async {
    try {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        print('imagePath==${_image}');
        // _uploadProfilePicture();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.orange[900],
                Colors.orange[800],
                Colors.orange[400],
              ])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              "SIGNUP",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height+150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60.0),
                            topRight: Radius.circular(60.0))),
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(20.0),
                            child: new Stack(fit: StackFit.loose, children: <Widget>[
                              new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Container(
                                    width: 140.0,
                                    height: 140.0,
                                    child: CircleAvatar(
                                      foregroundColor: Colors.white,
                                      radius: 60,
                                      backgroundColor: Colors.white,
                                      backgroundImage: (_image == null || _image == "")
                                          ? AssetImage('images/avatar.png')
                                          : FileImage(_image),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 90.0, right: 80.0),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          _selectProfilePicture();
                                        },
                                        child: new CircleAvatar(
                                          backgroundColor: Colors.orange.shade900,
                                          radius: 25.0,
                                          child: new Icon(
                                            Icons.camera_alt,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ]),
                          ),

                          SizedBox(height: 30.0),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(255, 95, 27, .3),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10),
                                )
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[200]))),
                                  child: TypeAheadFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please select a country';
                                        }
                                        return null;
                                      },
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                              decoration: InputDecoration(
                                                suffixIcon:
                                                    Icon(Icons.verified_user),
                                                border: InputBorder.none,
                                                hintText: 'Country prefrences',
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              controller:
                                                  this._typeAheadController),
                                      suggestionsCallback: (pattern) {
                                        return filterList(cities, pattern);
                                      },
                                      transitionBuilder: (context,
                                          suggestionsBox, controller) {
                                        return suggestionsBox;
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        //  print(suggestion.toString());
                                        this._typeAheadController.text =
                                            suggestion;
                                        setState(() {
                                          selectCountry = suggestion;
                                        });
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                            title: Text(suggestion));
                                      },
                                      onSaved: (value) {
                                        setState(() {
                                          selectCountry = value;
                                        });
                                      }),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[200]))),
                                  child: TextFormField(
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    validator: AppValidation.validateName,
                                    onChanged: (value) {
                                      firstName = value;
                                    },
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: 'First Name',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      suffixIcon: Icon(Icons.account_box),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[200]))),
                                  child: TextFormField(
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    validator: AppValidation.validateLastName,
                                    onChanged: (value) {
                                      lastName = value;
                                    },
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: 'Last Name',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      suffixIcon: Icon(Icons.account_box),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[200]))),
                                  child: TextFormField(
                                    validator: AppValidation.validateEmail,
                                    onChanged: (value) {
                                      email = value;
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintText: 'Email',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      suffixIcon: Icon(Icons.email),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[200]))),
                                  child: TextFormField(
                                    onChanged: (value) {
                                      password = value;
                                    },

                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      suffixIcon: Icon(Icons.lock),
                                    ),
                                    validator: (val) => val.length < 6
                                        ? 'Password too short.'
                                        : null,
                                    obscureText: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          RaisedButton(
                            padding: EdgeInsets.symmetric(
                                horizontal: 120.0, vertical: 13.0),
                            color: Colors.orange.shade900,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60.0),
                            ),
                            child: Text(
                              'REGISTER',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),

                            onPressed: () async {
                              print('its not working');
                              if (_formKey.currentState.validate()) {
                                if (_image == null) {
                                  MyUtils.showToastNormal(
                                      'Please select your profile picture');
                                  return;
                                }

                                setState(() {
                                  showSpinner = true;
                                });
                                try {
                                  AuthResult newUser =
                                      await auth.createUserWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  ) .then((newUser) async {
                                  if (newUser != null) {
                                    await saveUserData(newUser.user.uid);
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        BottomNav.routeName, (route) => false);
                                  }  }).catchError((onError) {
                                        print("Error in sign up: $onError");
                                        String exception =
                                        Auth.getExceptionText(onError);
                                        _showErrorAlert(
                                            title: "Signup failed",
                                            content: exception,
                                            onPressed: _changeBlackVisible);
                                      });
                                    setState(() {
                                      showSpinner = false;
                                    });
                                } catch (e) {
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  print(e);
                                }
                              }
                            },
                          ),
                          SizedBox(
                            height: 40,
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

  }
  void _showErrorAlert({String title, String content, VoidCallback onPressed}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          content: content,
          title: title,
          onPressed: onPressed,
        );
      },
    );
  }
  void _changeBlackVisible() {
    setState(() {
      _blackVisible = !_blackVisible;
    });
  }
  Future<Null> saveUserData(String userID) async {
    print(userID);
    Auth.addUser(User(
      userNameFirst: firstName,
      userNameLast: lastName,
      userEmail: email,
      userUID: userID,
      userPic: '',
      userCountry: selectCountry,
    ));
    SharedPreferenceData.setUserUID(userID);
    await _uploadProfilePicture(userID);
  }

  Future<Null> _uploadProfilePicture(String userID) async {
    try {
      setState(() {
        showSpinner = true;
      });
      String downloadUrl;
      final StorageReference ref =
          FirebaseStorage.instance.ref().child('profilePicture_${userID}.jpg');
      final StorageUploadTask uploadTask = ref.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      downloadUrl = await taskSnapshot.ref.getDownloadURL();
      Auth.updateProfilePic(User(userPic: downloadUrl, userUID: userID));
      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        showSpinner = false;
      });
    }
  }
}
