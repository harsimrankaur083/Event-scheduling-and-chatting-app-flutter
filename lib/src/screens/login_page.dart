import 'package:flutter_chat/src/business/shared_preference_data.dart';
import 'package:flutter_chat/src/business/user_auto.dart';
import 'package:flutter_chat/src/constants/app_validation.dart';
import 'package:flutter_chat/src/screens/forgot_password_page.dart';
import 'package:flutter_chat/src/widgets/custom_alert_dialog.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/src/screens/home/bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat/src/screens/register_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: LoginPage()));

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String password;
  final _formkey = GlobalKey<FormState>();

  final FirebaseAnalytics analytics = FirebaseAnalytics();
  final auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  bool _blackVisible = false;
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
                    height: 60.0,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "LOGIN",
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "Hey! welcome back",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height-100,
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
                            height: 40.0,
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
                            child: Column(
                              children: <Widget>[
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
                            height: 50.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, ForgotPassword.routeName);
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'forgot password?',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40.0,
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
                              'LOGIN',
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
                                  print(password);
                                  Auth.signIn(email, password);
                                  AuthResult newUser =
                                      await auth.signInWithEmailAndPassword(
                                          email: email, password: password).then((newUser) async {
                                        if (newUser.user.uid!= null) {
                                          print("new user");
                                          await SharedPreferenceData.setUserUID( newUser.user.uid);
                                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                              BottomNav()), (Route<dynamic> route) => false);}})
                                          .catchError((onError){
                                        print("Error in sign up: $onError");
                                        String exception = Auth.getExceptionText(onError);
                                        _showErrorAlert(
                                          title: "Signup failed",
                                          content: exception,
                                          onPressed: _changeBlackVisible,
                                        );
                                        setState(() {
                                          showSpinner = false;
                                        });
                                      });}catch(e){}
                              }



                            },
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RegisterPage.routeName);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Don't have an account ?",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "Sign up",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
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
}
