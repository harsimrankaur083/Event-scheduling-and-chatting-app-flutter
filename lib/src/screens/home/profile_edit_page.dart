import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/src/business/user_auto.dart';
import 'package:flutter_chat/src/constants/app_validation.dart';
import 'package:flutter_chat/src/model/user.dart';
import 'package:flutter_chat/src/screens/home/profile_view.dart';
import 'package:flutter_chat/src/utils/my_utils.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EditProfile extends StatefulWidget {
  static const routeName = '/edit_profile';

  @override
  _ProfileState createState() => _ProfileState();
}

FirebaseUser loggedInUser;

class _ProfileState extends State<EditProfile> {
  var userData;
  File _image;
  String pic;
  bool showSpinner = false;
  final TextEditingController _typeAheadController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController selectCountry = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController gender = TextEditingController();

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
  static final List<String> genderList = [
    'Female',
    'Male',
    'Transgender',

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
        _uploadProfilePicture();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    try {
      Auth.getCurrentFirebaseUser().then((value) {
        if (value != null) {
          setState(() {
            loggedInUser = value;
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('UserData').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data.documents.firstWhere(
                        ((doc) => doc.documentID == loggedInUser.uid));

                    firstName.text = data['userNameFirst'];
                    lastName.text = data['userNameLast'];
                    email.text = data['userEmail'];
                    phone.text = data['phone'] ?? "";
                    bio.text = data['bio'] ?? "";
                    pic = data['userPic'] ?? "";
                    _typeAheadController.text = data['userCountry'] ?? "";
                    gender.text = data['gender'] ?? "";
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              colors: [
                            Colors.orange[900],
                            Colors.orange[800],
                            Colors.orange[400],
                          ])),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 30.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
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
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  "Edit Profile",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          SingleChildScrollView(
                            child: Container(
                              height: MediaQuery.of(context).size.height + 180,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(60.0),
                                      topRight: Radius.circular(60.0))),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10.0,
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
                                                  backgroundImage:(pic==null||pic=="")?AssetImage("images/avatar.png")  : NetworkImage(pic),
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

                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color:
                                                          Colors.grey[200]))),
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
                                                      decoration:
                                                          InputDecoration(
                                                        suffixIcon: Icon(
                                                            Icons.language),
                                                        border:
                                                            InputBorder.none,
                                                        hintText: 'Country',
                                                        hintStyle: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                      controller: this
                                                          ._typeAheadController),
                                              suggestionsCallback: (pattern) {
                                                return filterList(
                                                    cities, pattern);
                                              },
                                              transitionBuilder: (context,
                                                  suggestionsBox, controller) {
                                                return suggestionsBox;
                                              },
                                              onSuggestionSelected:
                                                  (suggestion) {
                                                //  print(suggestion.toString());
                                                this._typeAheadController.text =
                                                    suggestion;
                                                print(
                                                    _typeAheadController.text);
                                              },
                                              itemBuilder:
                                                  (context, suggestion) {
                                                return ListTile(
                                                    title: Text(suggestion));
                                              },
                                              onSaved: (value) {
                                                setState(() {
                                                  _typeAheadController.text =
                                                      value;
                                                  print(_typeAheadController
                                                      .text);
                                                });
                                              }),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color:
                                                          Colors.grey[200]))),
                                          child: TextFormField(
                                            controller: firstName,
                                            textCapitalization:
                                                TextCapitalization.sentences,
                                            validator:
                                                AppValidation.validateName,
                                            onSaved: (value){ firstName.text = value;},
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                              hintText: 'First Name',
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              border: InputBorder.none,
                                              suffixIcon:
                                                  Icon(Icons.account_box),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color:
                                                          Colors.grey[200]))),
                                          child: TextFormField(
                                            controller: lastName,
                                            textCapitalization:
                                                TextCapitalization.sentences,
                                            validator:
                                                AppValidation.validateLastName,
                                            onSaved: (value){ lastName.text = value;},
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                              hintText: 'Last Name',
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              border: InputBorder.none,
                                              suffixIcon:
                                                  Icon(Icons.account_box),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color:
                                                          Colors.grey[200]))),
                                          child: TextFormField(
                                            controller: email,
                                            enabled: false,
                                            validator:
                                                AppValidation.validateEmail,
                                            onChanged: (value) {
                                              email.text = value;
                                            },
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            decoration: InputDecoration(
                                              hintText: 'Email',
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
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
                                                      color:
                                                      Colors.grey[200]))),
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
                                                  decoration:
                                                  InputDecoration(
                                                    suffixIcon: Icon(
                                                        Icons.child_care),
                                                    border:
                                                    InputBorder.none,
                                                    hintText: 'Gender',
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  controller: this
                                                      .gender),
                                              suggestionsCallback: (pattern) {
                                                return filterList(
                                                    genderList, pattern);
                                              },
                                              transitionBuilder: (context,
                                                  suggestionsBox, controller) {
                                                return suggestionsBox;
                                              },
                                              onSuggestionSelected:
                                                  (suggestion) {
                                                //  print(suggestion.toString());
                                                this.gender.text =
                                                    suggestion;
                                                print(
                                                    gender.text);
                                              },
                                              itemBuilder:
                                                  (context, suggestion) {
                                                return ListTile(
                                                    title: Text(suggestion));
                                              },
                                              onSaved: (value) {
                                                setState(() {
                                                  gender.text =
                                                      value;
                                                  print(gender
                                                      .text);
                                                });
                                              }),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color:
                                                          Colors.grey[200]))),
                                          child: TextFormField(
                                            controller: phone,
                                            onSaved: (value){ phone.text = value;},
                                            keyboardType: TextInputType.phone,
                                            decoration: InputDecoration(
                                              hintText: 'Phone',
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              border: InputBorder.none,
                                              suffixIcon: Icon(Icons.phone),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color:
                                                          Colors.grey[200]))),
                                          child: TextFormField(
                                            controller: bio,
                                            onSaved: (value){ bio.text = value;},
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: 4,
                                            minLines: 1,
                                            decoration: InputDecoration(
                                              hintText: 'Bio',
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              border: InputBorder.none,
                                              suffixIcon: Icon(Icons.blur_on),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    RaisedButton(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 120.0, vertical: 13.0),
                                      color: Colors.orange.shade900,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(60.0),
                                      ),
                                      child: Text(
                                        'Update',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      onPressed: () async {
                                        print('its not working');
                                        if (_formKey.currentState.validate()) {
                                          setState(() {
                                            showSpinner = true;
                                          });
                                          try {
                                            print(loggedInUser.uid);
                                            await Auth.addUpdateProfile(User(
                                                userNameFirst: firstName.text,
                                                userNameLast: lastName.text,
                                                userUID: loggedInUser.uid,
                                                userCountry:
                                                    _typeAheadController.text,
                                                bio: bio.text,
                                                gender: gender.text,
                                                phone: phone.text)).then((onValue) {
                                              MyUtils.toastMessage("Profile Updated Successfully");
                                              Navigator.of(context).pop();
                                            });

                                            // } else
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
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return Container();
                }),
          ),
        ),
      ),
    );
  }

  Future<Null> _uploadProfilePicture() async {
    try {
      setState(() {
        showSpinner = true;
      });
      String downloadUrl;
      final StorageReference ref = FirebaseStorage.instance
          .ref()
          .child('profilePicture_${loggedInUser.uid}.jpg');
      print('2');
      final StorageUploadTask uploadTask = ref.putFile(_image);
      print('3');
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      print('4');
      //  Uri location = (await uploadTask.future).downloadUrl;
      downloadUrl = await taskSnapshot.ref.getDownloadURL();
      print(downloadUrl);
      print(loggedInUser.uid);
      Auth.updateProfilePic(
          User(userPic: downloadUrl, userUID: loggedInUser.uid));
      setState(() {
        showSpinner = false;
      });
      print('5' + downloadUrl);
    } catch (e) {
      print(e);
      print('6');
      setState(() {
        showSpinner = false;
      });
    }
  }
}
