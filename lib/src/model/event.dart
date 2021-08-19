class Events {
  String eventTitle;
  String eventDate;
  String eventTime;
  String eventDescription;

  Events(
      {this.eventTitle, this.eventDate, this.eventDescription, this.eventTime});

  Map<String, Object> toJson() {
    return {
      'eventName': eventTitle,
      'desc': eventDescription,
      'date': eventDate == null ? '' : eventDate,
      'time': eventTime == null ? '' : eventTime,
    };
  }
}
