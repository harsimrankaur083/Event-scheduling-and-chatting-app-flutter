import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/src/business/user_auto.dart';
import 'package:flutter_chat/src/constants/app_validation.dart';
import 'package:flutter_chat/src/utils/my_utils.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ForgotPassword extends StatefulWidget {
  static const routeName = '/forgot_password';

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formkey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.orange[900],
                Colors.orange[800],
                Colors.orange[400],
              ])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 40.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: () {Navigator.pop(context);},
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              "Forgot Password",
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
                    height: 30,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height-80,
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
                            height: 70.0,
                          ),
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
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[200]))),
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
                          ),
                          SizedBox(
                            height: 60.0,
                          ),
                          RaisedButton(
                            padding: EdgeInsets.symmetric(
                                horizontal: 120.0, vertical: 13.0),
                            color: Colors.orange.shade900,
                            disabledColor: null,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60.0),
                            ),
                            child: Text(
                              'SUBMIT',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            onPressed: () async {
                              if (_formkey.currentState.validate()) {
                                setState(() {
                                  showSpinner = true;
                                });
                                try {
                                  print(email);
                                  Auth.resetPassword(email);
                                  MyUtils.showToastNormal('Please check your email to reset your password.');
                                  setState(() {
                                    showSpinner = false;
                                  });
                                } catch (e) {
                                  print(e);
                                }
                              }
                            },
                          ),
                          SizedBox(
                            height: 50,
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
}
