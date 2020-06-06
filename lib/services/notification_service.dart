import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:reminder_app/models/reminder.dart';

@lazySingleton
class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var initSettingsAndroid;
  var initSettingsIOS;
  var initSettings;

  void initNotificationsSettings() {
    initSettingsAndroid = AndroidInitializationSettings('app_icon');
    initSettingsIOS = IOSInitializationSettings();
    initSettings = InitializationSettings(initSettingsAndroid, initSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      print('Notification payload: $payload');
    }
  }

  void createReminder({@required Reminder reminder}) {
    var androidPlatformChannelSpecific = AndroidNotificationDetails(
      'channel Id',
      'channel Name',
      'channel Description',
      importance: Importance.Max,
      priority: Priority.High,
      color: reminder.marker,
    );
    var iOSChanelSpecific = IOSNotificationDetails();
    var platformChannelSpecifics =
        NotificationDetails(androidPlatformChannelSpecific, iOSChanelSpecific);
    flutterLocalNotificationsPlugin.schedule(reminder.id, reminder.title,
        reminder.text, reminder.when, platformChannelSpecifics,
        androidAllowWhileIdle: true);
  }

  Future<void> deleteReminder(int id) {
    return flutterLocalNotificationsPlugin.cancel(id);
  }
}
