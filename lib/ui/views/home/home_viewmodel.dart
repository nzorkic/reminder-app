import 'package:reminder_app/global/locator.dart';
import 'package:reminder_app/models/reminder.dart';
import 'package:reminder_app/services/database_service.dart';
import 'package:reminder_app/services/notification_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  DatabaseService databaseService = locator<DatabaseService>();
  NotificationService notificationService = locator<NotificationService>();

  Future<Map<ReminderState, List<Reminder>>> getUpcomingReminders(
      [ReminderState state]) async {
    Map<ReminderState, List<Reminder>> reminders = {};
    List<Reminder> allReminders = await databaseService.reminders();
    List<Reminder> upcoming = [];
    List<Reminder> today = [];
    for (Reminder reminder in allReminders) {
      if (ReminderState.values[reminder.state] == ReminderState.today) {
        today.add(reminder);
      } else if (ReminderState.values[reminder.state] ==
          ReminderState.upcoming) {
        upcoming.add(reminder);
      }
    }
    today.sort((a, b) => a.when.compareTo(b.when));
    upcoming.sort((a, b) => a.when.compareTo(b.when));
    reminders[ReminderState.today] = today;
    reminders[ReminderState.upcoming] = upcoming;
    return Future.value(reminders);
  }

  void onDelete(int id) async {
    await notificationService.deleteReminder(id);
    await databaseService.deleteReminder(id);
    notifyListeners();
    locator<NavigationService>().popRepeated(1);
  }

  void onDone(Reminder reminder) async {
    await notificationService.deleteReminder(reminder.id);
    reminder.state = ReminderState.values.indexOf(ReminderState.done);
    await databaseService.updateReminder(reminder);
    notifyListeners();
    locator<NavigationService>().popRepeated(1);
  }
}
