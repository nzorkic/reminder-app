import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/global/locator.dart';
import 'package:reminder_app/services/date_time_service.dart';

// Do not change the position of [upcoming]
enum ReminderState { upcoming, done, today }

// Do not change the position of [once]
enum Repeat { once, hourly, daily, weekly, monthly, yearly }

extension RepeatExtension on Repeat {
  String capitalize(String value) {
    return "${value[0].toUpperCase()}${value.substring(1)}";
  }

  String asString() => capitalize(EnumToString.parse(this));
}

class Reminder {
  int id;
  String text;
  DateTime when;
  String title;
  int repeat;
  int marker;
  String reportAs;
  String notifyInAdvance;
  int state;

  Reminder(
      {@required this.id,
      @required this.text,
      @required this.when,
      this.title = 'Reminder',
      this.repeat = 0,
      this.marker = 4279592384,
      this.reportAs = 'notification',
      this.notifyInAdvance = 'no',
      this.state = 0});

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
      'notify_in_advance': notifyInAdvance,
      'state': state,
    };
  }
}
