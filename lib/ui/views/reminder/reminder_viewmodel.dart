import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
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

  int reminderId;
  String selectedDate;
  String selectedTime;
  String formattedTime;
  String reminderText;
  Color selectedMarker = Colors.blue[800];
  int selectedRepeat = Repeat.values.indexOf(Repeat.once);

  ReminderViewModel() {
    selectedDate = dateTimeService.getDateAsString(dateTimeService.nextHour);
    selectedTime = dateTimeService.getTimeAsString(dateTimeService.nextHour);
    formattedTime = dateTimeService.getShortTimeAsString(selectedTime);
    reminderText = '';
  }

  ReminderViewModel.filled(
      {@required this.reminderId,
      @required this.reminderText,
      @required this.selectedDate,
      @required this.formattedTime,
      @required this.selectedRepeat,
      @required this.selectedMarker});

  void generateOrUpdateReminder() async {
    Reminder reminder = Reminder(
        id: reminderId == null ? Random().nextInt(9999999) : reminderId,
        text: reminderText,
        when: dateTimeService.stringToDate(
            date: selectedDate, time: selectedTime),
        marker: selectedMarker,
        repeat: selectedRepeat);
    locator<NotificationService>().createReminder(reminder: reminder);
    reminderId == null
        ? await locator<DatabaseService>().insertReminder(reminder)
        : await locator<DatabaseService>().updateReminder(reminder);
    locator<NavigationService>().replaceWith(Routes.homeViewRoute);
  }

  void reminderValueChanged(String value) {
    reminderText = value;
  }

  void dropTable() async {
    await locator<DatabaseService>().dropTableIfExistsThenReCreate();
  }

  void chooseDate(BuildContext context) async {
    DateTime newDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(2222));
    if (newDate != null) {
      selectedDate = dateTimeService.getDateAsString(newDate);
      notifyListeners();
    }
  }

  void _displayDialog(
      BuildContext context, String title, double height, Widget content) async {
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: height,
                  width: 300.0,
                  child: content,
                ),
              ],
            ),
          ),
          actions: [
            FlatButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text('SELECT'),
              onPressed: () {
                notifyListeners();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void chooseMarker(BuildContext context) {
    _displayDialog(
      context,
      'Pick a Marker',
      210.0,
      MaterialColorPicker(
          physics: const NeverScrollableScrollPhysics(),
          allowShades: false,
          selectedColor: Colors.blue[800],
          onMainColorChange: (Color color) => selectedMarker = color),
    );
  }

  void chooseRepeat(BuildContext context) {
    _displayDialog(
      context,
      'Repeat',
      350.0,
      ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(6.0),
        itemCount: Repeat.values.length,
        itemBuilder: (context, index) {
          return RadioListTile<int>(
              title: Text(Repeat.values[index].asString()),
              value: index,
              groupValue: selectedRepeat,
              onChanged: (int value) {
                selectedRepeat = value;
                notifyListeners();
              });
        },
      ),
    );
  }

  void chooseTime(BuildContext context) async {
    TimeOfDay parsedTime = TimeOfDay.fromDateTime(
        dateTimeService.stringToDate(date: selectedDate, time: selectedTime));
    TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: parsedTime,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );
    if (newTime != null) {
      selectedTime = dateTimeService.timeToString(newTime);
      formattedTime = dateTimeService.getShortTimeAsString(selectedTime);
      notifyListeners();
    }
  }
}
