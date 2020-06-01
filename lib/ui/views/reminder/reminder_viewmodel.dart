import 'dart:math';

import 'package:flutter/material.dart';
import 'package:reminder_app/global/router.gr.dart';
import 'package:reminder_app/models/reminder.dart';
import 'package:reminder_app/services/database_service.dart';
import 'package:reminder_app/services/notification_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../global/locator.dart';
import '../../../services/date_time_service.dart';

class ReminderViewModel extends BaseViewModel {
  DateTimeService dateTimeService = locator<DateTimeService>();

  String _selectedDate;
  String _selectedTime;
  String formattedTime;
  String reminderText;

  ReminderViewModel() {
    _selectedDate = dateTimeService.getDateAsString(dateTimeService.nextHour);
    _selectedTime = dateTimeService.getTimeAsString(dateTimeService.nextHour);
    formattedTime = dateTimeService.getShortTimeAsString(_selectedTime);
    reminderText = '';
  }

  String get selectedDate => _selectedDate;

  void generateReminder() async {
    Reminder reminder = Reminder(
      id: Random().nextInt(9999999),
      text: reminderText,
      when: dateTimeService.stringToDate(
          date: _selectedDate, time: _selectedTime),
    );
    locator<NotificationService>().createReminder(reminder: reminder);
    await locator<DatabaseService>().insertReminder(reminder);
    locator<NavigationService>().navigateTo(Routes.homeViewRoute);
  }

  void reminderValueChanged(String value) {
    reminderText = value;
  }

  void chooseDate(BuildContext context) async {
    DateTime newDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(2222));
    if (newDate != null) {
      _selectedDate = dateTimeService.getDateAsString(newDate);
      notifyListeners();
    }
  }

  void chooseTime(BuildContext context) async {
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(
        dateTimeService.stringToDate(date: _selectedDate, time: _selectedTime));
    TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );
    if (newTime != null) {
      _selectedTime = dateTimeService.timeToString(newTime);
      formattedTime = dateTimeService.getShortTimeAsString(_selectedTime);
      notifyListeners();
    }
  }
}
