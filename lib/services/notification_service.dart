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

  void showNotification() async {
    await _demoNotification();
  }

  Future<void> _demoNotification() async {
    var androidPlatformChannelSpecific = AndroidNotificationDetails(
        'channel Id', 'channel Name', 'channel Description',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'test ticker');
    var iOSChanelSpecific = IOSNotificationDetails();
    var platformChannelSpecifics =
        NotificationDetails(androidPlatformChannelSpecific, iOSChanelSpecific);
    await flutterLocalNotificationsPlugin.show(
        1, 'Tite on not', 'body of not', platformChannelSpecifics,
        payload: 'test payload');
  }
}
