import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../global/locator.dart';
import '../../../services/date_time_service.dart';

class ReminderViewModel extends BaseViewModel {
  DateTimeService dateTimeService = locator<DateTimeService>();

  String _selectedDate;
  String _selectedTime;
  String formattedTime;

  Map payload;

  ReminderViewModel() {
    _selectedDate = dateTimeService.getDateAsString(dateTimeService.nextHour);
    _selectedTime = dateTimeService.getTimeAsString(dateTimeService.nextHour);
    formattedTime = dateTimeService.getShortTimeAsString(_selectedTime);
    payload = <String, dynamic>{
      'date_time': dateTimeService.nextHour,
      'repeat': 'once',
      'marker': Colors.red,
      'report_as': 'notification',
      'notify_in_advance': 'not_specified'
    };
  }

  void generateReminder() {}

  String get selectedDate => _selectedDate;

  String get selectedTime => _selectedTime;

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
      formattedTime = dateTimeService
          .getShortTimeAsString(dateTimeService.timeToString(newTime));
      notifyListeners();
    }
  }
}
