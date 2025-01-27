import 'dart:async';
import 'dart:ui';

import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:reminder_app/global/locator.dart';
import 'package:reminder_app/models/reminder.dart';
import 'package:reminder_app/services/date_time_service.dart';
import 'package:sqflite/sqflite.dart';

@lazySingleton
class DatabaseService {
  static const String REMINDER_TABLE = 'reminders';

  Future<Database> _getDatabase() async {
    Database database = await openDatabase(
      join(await getDatabasesPath(), 'reminders.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $REMINDER_TABLE(id INTEGER PRIMARY KEY,'
          ' text TEXT, title TEXT, time TEXT, date TEXT, repeat INTEGER,'
          ' marker INTEGER, report_as TEXT, notify_in_advance TEXT, state INTEGER)',
        );
      },
      version: 1,
    );
    return database;
  }

  Future<void> dropTableIfExistsThenReCreate() async {
    final Database db = await _getDatabase();
    await db.execute("DROP TABLE IF EXISTS $REMINDER_TABLE");
    await db.execute(
        'CREATE TABLE $REMINDER_TABLE(id INTEGER PRIMARY KEY, text TEXT,'
        ' title TEXT, time TEXT, date TEXT, repeat INTEGER, marker INTEGER,'
        ' report_as TEXT, notify_in_advance TEXT, state INTEGER)');
    print('NEW TABLE CREATED!');
  }

  Future<void> insertReminder(Reminder reminder) async {
    final Database db = await _getDatabase();
    await db.insert(REMINDER_TABLE, reminder.toMap(),
        conflictAlgorithm: ConflictAlgorithm.rollback);
  }

  Future<List<Reminder>> reminders() async {
    final Database db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(REMINDER_TABLE);

    return List.generate(maps.length, (i) {
      final DateTime date = locator<DateTimeService>()
          .stringToDate(date: maps[i]['date'], time: maps[i]['time']);
      final int state = _getReminderState(date, maps[i]['state']);
      return Reminder(
        id: maps[i]['id'],
        text: maps[i]['text'],
        title: maps[i]['title'],
        when: date,
        repeat: maps[i]['repeat'],
        marker: Color(maps[i]['marker']),
        reportAs: maps[i]['report_as'],
        notifyInAdvance: maps[i]['notify_in_advance'],
        state: state,
      );
    });
  }

  Future<void> updateReminder(Reminder reminder) async {
    final Database db = await _getDatabase();
    await db.update(
      REMINDER_TABLE,
      reminder.toMap(),
      where: "id = ?",
      whereArgs: [reminder.id],
    );
  }

  Future<void> deleteReminder(int id) async {
    final Database db = await _getDatabase();
    await db.delete(
      REMINDER_TABLE,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  int _getReminderState(DateTime date, int state) {
    int indexOfDone = ReminderState.values.indexOf(ReminderState.done);
    DateTimeService dateTimeService = locator<DateTimeService>();
    if (state == indexOfDone || date.isBefore(DateTime.now()))
      return indexOfDone;
    if (dateTimeService.isToday(date)) {
      state = ReminderState.values.indexOf(ReminderState.today);
    } else if (dateTimeService.isPast(date)) {
      state = indexOfDone;
    }
    return state;
  }
}
