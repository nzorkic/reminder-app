import 'package:flutter/material.dart';
import 'package:reminder_app/global/locator.dart';
import 'package:reminder_app/services/date_time_service.dart';

enum ReminderState {
  upcoming,
  done
}

class Reminder {
  int id;
  String text;
  DateTime when;
  String title;
  String repeat;
  String marker;
  String reportAs;
  String notifyInAdvance;

  Reminder(
      {@required this.id,
      @required this.text,
      @required this.when,
      this.title = 'Reminder',
      this.repeat = 'Once',
      this.marker = '',
      this.reportAs = 'notification',
      this.notifyInAdvance = 'no'});

  String get date => locator<DateTimeService>().getDateAsString(when);

  String get time => locator<DateTimeService>().getShortTimeAsString(when);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'title': title,
      'time': locator<DateTimeService>().getTimeAsString(when),
      'date': locator<DateTimeService>().getDateAsString(when),
      'repeat': repeat,
      'marker': marker,
      'report_as': reportAs,
      'notify_in_advance': notifyInAdvance
    };
  }
}
