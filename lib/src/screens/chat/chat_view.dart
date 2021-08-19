import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat/src/business/user_auto.dart';
import 'package:flutter_chat/src/model/chat_data.dart';
import 'package:flutter_chat/src/model/user.dart';
import 'package:flutter_chat/src/notification/send_notification.dart';
import 'package:intl/intl.dart';

FirebaseUser loggedInUser;

class ChatView extends StatefulWidget {
  String receivedId;
  String userDeviceID;

  ChatView({this.receivedId, this.userDeviceID});

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final _auth = FirebaseAuth.instance;
  String id = "";
  TextEditingController msgController = new TextEditingController();

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
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
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    print(makeUniqueId(widget.receivedId));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange[900],
          title: Text(
            'Chat',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.normal),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('chatRoom')
                  .document(id)
                  .collection("userChat")
                  .orderBy("timeDate", descending: false)
                  .limit(30)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }

                final messagesSnapshot = snapshot.data.documents.reversed;
                List<MessageBubble> messageBubbles = [];
                for (var message in messagesSnapshot) {
                  final messageText = message.data['chatMessage'];
                  final messageSender = message.data['senderId'];
                  final messageEmail = message.data['email'];
                  final timeDate = message.data['timeDate'];
                  //   final userDeviceID = message.data['userDeviceID'] ?? null;
                  final currentUser = loggedInUser.uid;
                  final messageBubble = MessageBubble(
                    sender: messageSender,
                    text: messageText,
                    isMe: currentUser == messageSender,
                    email: messageEmail,
                    timeDate: timeDate,
                    // userDeviceID: userDeviceID,
                  );

                  messageBubbles.add(messageBubble);
                }
                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                    children: messageBubbles,
                  ),
                );
              },
            ),
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    controller: msgController,
                    decoration: InputDecoration(
                      hintText: 'send a message',
                      hintStyle: TextStyle(color: Colors.black26),
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(30.0),
                        ),
                      ),
                    ),
                  )),
                  SizedBox(width: 5),
                  RaisedButton(
                      padding: EdgeInsets.all(15),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 30,
                      ),
                      color: Colors.black,
                      shape: CircleBorder(),
                      onPressed: () async {
                        String message = msgController.text;
                        sendMessage(
                            ChatData(
                                chatMessage: msgController.text,
                                email: loggedInUser.email,
                                senderId: loggedInUser.uid,
                                timeDate: DateFormat.jm()
                                    .format(DateTime.now())
                                    .toString()),
                            id);
                        if (widget.userDeviceID != null) {
                          await SendNotification.sendFcmMessage(
                              loggedInUser.email, message, widget.userDeviceID);
                        }
                      })
                ],
              ),
            ),
          ],
        ));
  }

  String makeUniqueId(String receiverId) {
    String myId = loggedInUser.uid;
    if (receiverId.hashCode <= myId.hashCode) {
      id = '${myId}_${receiverId}';
    } else {
      id = '${receiverId}_${myId}';
    }
    return id;
  }

  void sendMessage(ChatData message, String chatRoomId) {
    if (message.chatMessage.length > 0) {
      Firestore.instance
          .collection("chatRoom")
          .document(chatRoomId)
          .collection("userChat")
          .add(message.toJson());
      msgController.clear();
    }
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe, this.email, this.timeDate});

  final String timeDate;
  final String sender;
  final String text;
  final String email;

//  final String userDeviceID;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: StreamBuilder(
            stream: Auth.getUser(loggedInUser.uid),
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              final eventsSnapshot = snapshot.data;

              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                      Color.fromRGBO(212, 20, 15, 1.0),
                    ),
                  ),
                );
              } else
                return Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: <Widget>[

                    Row(
                      mainAxisAlignment: isMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * .6),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.orange[700] : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 5.0,
                                  color: Colors.grey,
                                  offset: Offset(0.0, 3.0))
                            ],
                            borderRadius: isMe
                                ? BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0),
                                    bottomRight: Radius.circular(30.0))
                                : BorderRadius.only(
                                    bottomLeft: Radius.circular(30.0),
                                    bottomRight: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                  ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 20.0),
                            child: Text(
                              text,
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black,
                                fontSize: 15.0,
                              ),
                              textScaleFactor: 1.1,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        CircleAvatar(
                          radius: isMe?20.0:0.0,
                          backgroundColor: Colors.white,
                          backgroundImage: isMe
                              ? (eventsSnapshot.userPic != null &&
                                      eventsSnapshot.userPic.isNotEmpty)
                                  ? NetworkImage(eventsSnapshot.userPic)
                                  : AssetImage('images/user.png')
                              : null,
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Text(email,textScaleFactor: 1.0,style:TextStyle(color: Colors.black,fontSize: 10)),

                    Text(
                      timeDate,
                      style: TextStyle(
                          color: Colors.grey.shade900,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                );
            }));
  }
}
