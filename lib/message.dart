import 'profile.dart';

class Message {
  final String user;
  final String body;
  final DateTime timeStamp;
  final String id;
  final String photo;

  Message({
    this.user,
    this.body,
    this.timeStamp,
    this.id,
    this.photo,
  });

  convertTimeStamp(DateTime timeStamp) {
    String month;
    String weekday;
    switch (timeStamp.month) {
      case 1:
        month = "Jan";
        break;
      case 2:
        month = "Feb";
        break;
      case 3:
        month = "Mar";
        break;
      case 4:
        month = "Apr";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "Jun";
        break;
      case 7:
        month = "Jul";
        break;
      case 8:
        month = "Aug";
        break;
      case 9:
        month = "Sep";
        break;
      case 10:
        month = "Oct";
        break;
      case 11:
        month = "Nov";
        break;
      case 12:
        month = "Dec";
        break;
    }
    switch (timeStamp.weekday) {
      case 1:
        weekday = "Mon";
        break;
      case 2:
        weekday = "Tues";
        break;
      case 3:
        weekday = "Wed";
        break;
      case 4:
        weekday = "Thur";
        break;
      case 5:
        weekday = "Fri";
        break;
      case 6:
        weekday = "Sat";
        break;
      case 7:
        weekday = "Sun";
        break;
    }
    return "$weekday, $month ${timeStamp.day}, ${timeStamp.year}";
  }
}