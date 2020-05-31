// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:reminder_app/ui/views/home/home_view.dart';
import 'package:reminder_app/ui/views/reminder/reminder_view.dart';

abstract class Routes {
  static const homeViewRoute = '/';
  static const reminderViewRoute = '/reminder-view-route';
  static const all = {
    homeViewRoute,
    reminderViewRoute,
  };
}

class Router extends RouterBase {
  @override
  Set<String> get allRoutes => Routes.all;

  @Deprecated('call ExtendedNavigator.ofRouter<Router>() directly')
  static ExtendedNavigatorState get navigator =>
      ExtendedNavigator.ofRouter<Router>();

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.homeViewRoute:
        if (hasInvalidArgs<HomeViewArguments>(args)) {
          return misTypedArgsRoute<HomeViewArguments>(args);
        }
        final typedArgs = args as HomeViewArguments ?? HomeViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => HomeView(key: typedArgs.key),
          settings: settings,
        );
      case Routes.reminderViewRoute:
        if (hasInvalidArgs<ReminderViewArguments>(args)) {
          return misTypedArgsRoute<ReminderViewArguments>(args);
        }
        final typedArgs =
            args as ReminderViewArguments ?? ReminderViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => ReminderView(key: typedArgs.key),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

// *************************************************************************
// Arguments holder classes
// **************************************************************************

//HomeView arguments holder class
class HomeViewArguments {
  final Key key;
  HomeViewArguments({this.key});
}

//ReminderView arguments holder class
class ReminderViewArguments {
  final Key key;
  ReminderViewArguments({this.key});
}
