class ChatData {
  String chatMessage;
  String senderId;
  String timeDate;
  String email;
  String userDeviceID;

  ChatData({this.chatMessage, this.senderId, this.timeDate,this.email});

  Map<String, Object> toJson() {
    return {
      'chatMessage': chatMessage,
      'senderId': senderId,
      'email': email,
      'userDeviceID':userDeviceID== null ? null : userDeviceID,
      'timeDate': timeDate == null ? '' : timeDate,
    };
  }
}
