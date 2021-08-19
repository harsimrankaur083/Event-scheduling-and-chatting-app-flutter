import 'dart:async';

import 'package:flutter_chat/src/business/user_event.dart';
import 'package:flutter_chat/src/model/event.dart';
import 'package:flutter_chat/src/utils/my_utils.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

FirebaseUser loggedInUser;

class EventEntry extends StatefulWidget {
  static const routeName = '/event_create';
  @override
  _EventEntryState createState() => _EventEntryState();
}

class _EventEntryState extends State<EventEntry> {
  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  DateTime pickedDate;
  String timeText = 'Set A Time';
  String ename;
  String desc;
  String time;
  String date;
  TextEditingController dateController = new TextEditingController();
  TextEditingController timeController = new TextEditingController();
  TextEditingController titleController = new TextEditingController();
  TextEditingController descController = new TextEditingController();
  bool showSpinner = false;

  Future<Null> _selectDate2(BuildContext context) async {
    DatePicker.showDatePicker(
      context,
      theme: DatePickerTheme(
        containerHeight: 210.0,
      ),
      showTitleActions: true,
      minTime: DateTime(2020, 1, 1),
      maxTime: DateTime(2022, 12, 31),
      onConfirm: (date) {
        if (date != null) {
          print('confirm $date');
          setState(() {
            _date = '${date.year} - ${date.month} - ${date.day}';
            dateController.value = TextEditingValue( text: DateFormat.yMMMMd("en_US").format(date).toString());
          });
        }
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en,
    );
  }

  Future<Null> _selectTime(BuildContext context) async {
    DatePicker.showTimePicker(context,
        theme: DatePickerTheme(
          containerHeight: 210.0,
        ),
        showTitleActions: true, onConfirm: (time) {
      if (time != null) {
        print('confirm $time');
        setState(() {
          _time = '${time.hour} : ${time.minute}';
          timeController.value = TextEditingValue(text: DateFormat.jm().format(time));
        });
      }
    }, currentTime: DateTime.now(), locale: LocaleType.en);
    setState(() {});
  }

  void getCurrentUser() async {
    try {
      final user = await auth.currentUser();
      if (user != null) {
        setState(() {
          loggedInUser = user;
          print(loggedInUser);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    getCurrentUser();
  }

  String _time = 'Not Set';
  String _date = 'Not Set';

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: SingleChildScrollView(
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
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
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
                            "Add Event Here",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height + 80,
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
                                      controller: titleController,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      keyboardType: TextInputType.text,
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return ('Please enter event title');
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Event Title',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                        suffixIcon: Icon(Icons.add_comment),
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
                                      controller: descController,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 6,
                                      minLines: 1,
                                      decoration: InputDecoration(
                                        labelText: 'Event Description',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                        suffixIcon: Icon(Icons.description),
                                      ),
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return ('Please enter event description');
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[200]))),
                                    child: TextFormField(
                                      enableInteractiveSelection: false,
                                      autofocus: false,
                                      controller: dateController,
                                      onTap: () {
                                        MyUtils.keyBordDown(context);
                                        _selectDate2(context);
                                      },
                                      onChanged: (value) {
                                        date = value;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Select Date',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                        suffixIcon: Icon(Icons.date_range),
                                      ),
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return ('Please select event date');
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[200]))),
                                    child: TextFormField(
                                      enableInteractiveSelection: false,
                                      autofocus: false,
                                      controller: timeController,
                                      onTap: () {
                                        MyUtils.keyBordDown(context);
                                        _selectTime(context);
                                      },
                                      onChanged: (value) {
                                        date = value;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Select Time',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                        suffixIcon: Icon(Icons.access_time),
                                      ),
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return ('Please select event time');
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 50.0,
                            ),
                            RaisedButton(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 120.0, vertical: 13.0),
                              color: Colors.orange.shade900,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60.0),
                              ),
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    showSpinner = true;
                                  });
                              LogicEvent().addEvent(uid:  loggedInUser.uid,
                                      events:Events(
                                        eventTitle: titleController.text,
                                        eventDescription: descController.text,
                                        eventDate: dateController.text,
                                        eventTime: timeController.text,
                                      )).then((onValue) {
                                MyUtils.toastMessage("Event Added Successfully");
                                Navigator.of(context).pop();
                              });
                                  setState(() {
                                    showSpinner = false;
                                  });

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
      ),
    );
  }
}

