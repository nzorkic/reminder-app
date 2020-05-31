import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

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

  void createReminder({@required Map<String, dynamic> payload}) {
    var androidPlatformChannelSpecific = AndroidNotificationDetails(
      'channel Id',
      'channel Name',
      'channel Description',
      importance: Importance.Max,
      priority: Priority.High,
      color: payload['marker'],
    );
    var iOSChanelSpecific = IOSNotificationDetails();
    var platformChannelSpecifics =
        NotificationDetails(androidPlatformChannelSpecific, iOSChanelSpecific);
    flutterLocalNotificationsPlugin.schedule(
        Random().nextInt(9999999),
        'Reminder!',
        payload['text'],
        payload['date_time'],
        platformChannelSpecifics,
        androidAllowWhileIdle: true);
  }
}
