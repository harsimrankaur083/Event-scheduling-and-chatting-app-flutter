import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/src/business/user_auto.dart';
import 'package:flutter_chat/src/screens/home/event_list_page.dart';
import 'package:flutter_chat/src/screens/home/profile_edit_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ProfileView extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}
FirebaseUser loggedInUser;
class _EditProfileState extends State<ProfileView> {
  final _formkey = GlobalKey<FormState>();
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  final auth = FirebaseAuth.instance;
  bool showSpinner = false;

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
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
          key: _formkey,
          child: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Scaffold(
              body: SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('UserData').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var data = snapshot.data.documents.firstWhere(
                            ((doc) => doc.documentID == loggedInUser.uid));
                        print(data.toString());
                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange[100],
                                Colors.orange[200],
                              ],begin: Alignment.bottomLeft,
                              end:  Alignment.centerLeft,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Stack(    alignment: Alignment.topLeft,
                              children: <Widget>[

                                Positioned(
                                  top: -MediaQuery.of(context).size.height * .18,
                                  right: -MediaQuery.of(context).size.width * .3,
                                  child: BezierContainer(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(150, 100, 0, 0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.orange.shade900,
                                    radius: 50,
                                    backgroundImage: (data['userPic'] == null ||
                                        data['userPic'] == "")
                                        ? AssetImage('images/avatar.png')
                                        : NetworkImage(data['userPic']),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top:150.0),
                                  child: Container(
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          children: <Widget>[




                                            SizedBox(
                                              height: 50.0,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[

                                                Container(
                                                  child: FlatButton(
                                                      splashColor: Colors.orange,
                                                      onPressed: () {},
                                                      child: Text(
                                                        data['userNameFirst'] +
                                                            " " +
                                                            data['userNameLast'],
                                                        style: TextStyle(
                                                            color: Colors.orange[900],
                                                            fontSize: 22),
                                                      )),
                                                ),
                                                GestureDetector(
                                                  onTap: (){
                                                    Navigator.pushNamed(context, EditProfile.routeName);
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Align(
                                                        alignment: Alignment.centerRight,
                                                        child: Container(
                                                          child: Icon(Icons.edit),
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15.0,
                                            ),
                                            Container(
                                              margin: EdgeInsets.all(5.0),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(10.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                    Color.fromRGBO(255, 95, 27, .3),
                                                    blurRadius: 20.0,
                                                    offset: Offset(3, 10),
                                                  )
                                                ],
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(20.0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.max,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text('Email',style: TextStyle(color: Colors.grey.shade500),textAlign: TextAlign.start,),
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(

                                                            child: Text(data['userEmail'],style: TextStyle(fontSize: 16.0),)
                                                        ),
                                                        Icon(Icons.account_box,color:Colors.grey.shade500),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        height: 30.0,
                                                        child: Divider(
                                                          color: Colors.grey.shade300,
                                                          thickness: 1.0,
                                                        )),
                                                    Text('Country',style: TextStyle(color: Colors.grey.shade500),textAlign: TextAlign.start,),
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(

                                                            child: Text(data['userCountry'],style: TextStyle(fontSize: 16.0),)
                                                        ),
                                                        Icon(Icons.language,color:Colors.grey.shade500),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        height: 30.0,
                                                        child: Divider(
                                                          color: Colors.grey.shade300,
                                                          thickness: 1.0,
                                                        )),
                                                    Text('Bio',style: TextStyle(color: Colors.grey.shade500),textAlign: TextAlign.start,),
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(

                                                            child: Text(data['bio'],style: TextStyle(fontSize: 16.0),)

                                                        ),
                                                        Icon(Icons.blur_on,color:Colors.grey.shade500 ,),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        height: 30.0,
                                                        child: Divider(
                                                          color: Colors.grey.shade300,
                                                          thickness: 1.0,
                                                        )),
                                                    Text('Phone Number',style: TextStyle(color: Colors.grey.shade500),textAlign: TextAlign.start,),
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(

                                                            child: Text(data['phone'],style: TextStyle(fontSize: 16.0),)

                                                        ),
                                                        Icon(Icons.call,color:Colors.grey.shade500),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                              ],),

                            ],
                          ),
                        );
                      }
                      return Container();
                    }),
              ),
            ),
          )),
    );
  }
}
class BezierContainer extends StatelessWidget {
  const BezierContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Transform.rotate(
          angle: -pi / 3.5,
          child: ClipPath(
            clipper: ClipPainter(),
            child: Container(
              height: MediaQuery.of(context).size.height *.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xfffbb448),Color(0xffe46b10)]
                  )
              ),
            ),
          ),
        )
    );
  }
}
class ClipPainter extends CustomClipper<Path>{
  @override

  Path getClip(Size size) {
    var height = size.height;
    var width = size.width;
    var path = new Path();

    path.lineTo(0, size.height );
    path.lineTo(size.width , height);
    path.lineTo(size.width , 0);

    /// [Top Left corner]
    var secondControlPoint =  Offset(0  ,0);
    var secondEndPoint = Offset(width * .1  , height *.3);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);



    /// [Left Middle]
    var fifthControlPoint =  Offset(width * .3  ,height * .5);
    var fiftEndPoint = Offset(  width * .23, height *.6);
    path.quadraticBezierTo(fifthControlPoint.dx, fifthControlPoint.dy, fiftEndPoint.dx, fiftEndPoint.dy);


    /// [Bottom Left corner]
    var thirdControlPoint =  Offset(0  ,height);
    var thirdEndPoint = Offset(width , height  );
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy, thirdEndPoint.dx, thirdEndPoint.dy);



    path.lineTo(0, size.height  );
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }


}