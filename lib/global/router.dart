import 'package:auto_route/auto_route_annotations.dart';

import '../ui/views/home/home_view.dart';
import '../ui/views/reminder/reminder_view.dart';

@MaterialAutoRouter()
class $Router {
  @initial
  HomeView homeViewRoute;
  ReminderView reminderViewRoute;
}
