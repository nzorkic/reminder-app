import 'package:reminder_app/global/locator.dart';
import 'package:reminder_app/models/reminder.dart';
import 'package:reminder_app/services/database_service.dart';
import 'package:reminder_app/services/notification_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  List<Reminder> reminders = [];

  DatabaseService databaseService = locator<DatabaseService>();
  NotificationService notificationService = locator<NotificationService>();

  void getReminders([ReminderState state]) async {
    reminders = await databaseService.reminders();
  }

  void deleteReminder(int id) async {
    await notificationService.deleteReminder(id);
    await databaseService.deleteReminder(id);
    reminders.removeWhere((element) => element.id == id);
    notifyListeners();
    locator<NavigationService>().popRepeated(1);
  }
}
