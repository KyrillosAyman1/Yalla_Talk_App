import 'package:intl/intl.dart';

class MyDateTime {
  static DateTime getDateTime({required String time}) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static String getDateTimeString({required String time}) {
    String date = "";
      var dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    date = DateFormat("jm").format(dateTime).toString();
    return date;
  }

  static String getDateAndTimeString({required String time}) {
    String date = "";
    var dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    final todayDate = (today.year, today.month, today.day);
    final yesterdayDate = (yesterday.year, yesterday.month, yesterday.day);
    final dateTimeDate = (dateTime.year, dateTime.month, dateTime.day);
    if(dateTimeDate == todayDate) {
      date = "Today";
    }
    else if(dateTimeDate == yesterdayDate) {
      date = "Yesterday";
    }
    else if(dateTime.year == today.year) {
      date = DateFormat.MMMd().format(dateTime).toString();

    }
    else {
      date = DateFormat.yMMMd().format(dateTime).toString();
    }

    return date;
  }
}
