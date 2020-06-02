import 'package:reminder_app/global/locator.dart';
import 'package:reminder_app/models/reminder.dart';
import 'package:reminder_app/services/database_service.dart';
import 'package:reminder_app/services/notification_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  DatabaseService databaseService = locator<DatabaseService>();
  NotificationService notificationService = locator<NotificationService>();

  Future<List<Reminder>> getReminders([ReminderState state]) {
    return databaseService.reminders();
  }

  void deleteReminder(int id) async {
    await notificationService.deleteReminder(id);
    await databaseService.deleteReminder(id);
    notifyListeners();
    locator<NavigationService>().popRepeated(1);
  }
}
