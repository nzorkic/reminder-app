import 'package:flutter/material.dart';
import 'package:reminder_app/global/locator.dart';
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
    return MaterialApp(
      title: "Dashboard",
      initialRoute: Routes.homeViewRoute,
      onGenerateRoute: Router().onGenerateRoute,
      navigatorKey: locator<NavigationService>().navigatorKey,
    );
  }
}
