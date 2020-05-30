import 'package:flutter/material.dart';
import 'package:reminder_app/global/locator.dart';
import 'package:reminder_app/services/notification_service.dart';
import 'package:stacked_services/stacked_services.dart';

import 'global/router.gr.dart';

void main() {
  setupLocator();
  runApp(ReminderApp());
}

class ReminderApp extends StatelessWidget {
  const ReminderApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    locator<NotificationService>().initNotificationsSettings();
    return MaterialApp(
      title: "Dashboard",
      initialRoute: Routes.homeViewRoute,
      onGenerateRoute: Router().onGenerateRoute,
      navigatorKey: locator<NavigationService>().navigatorKey,
    );
  }
}
