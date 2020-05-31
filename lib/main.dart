import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked_services/stacked_services.dart';

import 'global/locator.dart';
import 'global/router.gr.dart';
import 'services/notification_service.dart';

void main() {
  setupLocator();
  runApp(ReminderApp());
}

class ReminderApp extends StatelessWidget {
  const ReminderApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    locator<NotificationService>().initNotificationsSettings();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      theme: ThemeData.dark(),
      title: "Dashboard",
      initialRoute: Routes.homeViewRoute,
      onGenerateRoute: Router().onGenerateRoute,
      navigatorKey: locator<NavigationService>().navigatorKey,
    );
  }
}
