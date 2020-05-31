import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DateTimeService {
  DateTime nextHour;

  DateTimeService() {
    nextHour = hourAhead();
  }

  DateTime hourAhead() {
    DateTime now = DateTime.now().toLocal();
    String nowStr = now.toString();
    String incrementedHour = (now.hour + 1).toString();
    String nextHour = nowStr.replaceFirstMapped(RegExp(' \\d+:.+'), (match) {
      if (incrementedHour.length == 1) incrementedHour = '0$incrementedHour';
      return ' $incrementedHour:00:00.000';
    });
    return DateTime.parse(nextHour);
  }

  String getDateAsString(DateTime date) => date.toString().split(' ')[0];

  String getTimeAsString(DateTime date) => date.toString().split(' ')[1];

  String getShortTimeAsString(var date) {
    String shortTime = '';
    if (date is DateTime) {
      final timeChunks = date.toString().split(' ')[1].split(':');
      shortTime = '${timeChunks[0]}:${timeChunks[1]}';
    }
    if (date is String) {
      if (date.contains(' ')) {
        final timeChunks = date.split(' ')[1].split(':');
        shortTime = '${timeChunks[0]}:${timeChunks[1]}';
      } else {
        final timeChunks = date.split(':');
        shortTime = '${timeChunks[0]}:${timeChunks[1]}';
      }
    }
    return shortTime;
  }

  DateTime stringToDate({@required String date, String time}) {
    if (time != null) {
      return DateTime.parse(date + ' $time');
    }
    return DateTime.parse(date);
  }

  String timeToString(TimeOfDay time) {
    String hour = '${time.hour}'.length == 1 ? '0${time.hour}' : '${time.hour}';
    String minute =
        '${time.minute}'.length == 1 ? '0${time.minute}' : '${time.minute}';
    return '$hour:$minute:00.000';
  }
}
