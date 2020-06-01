import 'package:flutter/material.dart';
import 'package:reminder_app/models/reminder.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../global/locator.dart';
import '../../../global/router.gr.dart';
import 'home_viewmodel.dart';

class HomeView extends StatelessWidget {
  HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      builder: (context, model, child) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(Icons.view_headline),
            title: Text('Dashboard'),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.search),
              )
            ],
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  text: "All",
                  icon: Icon(Icons.assignment),
                ),
                Tab(
                  text: "Favorites",
                  icon: Icon(Icons.star),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              _buildReminderList(model, context),
              Center(
                child: Text("Favorites Tab"),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => locator<NavigationService>()
                .navigateTo(Routes.reminderViewRoute),
            child: Icon(Icons.add),
          ),
        ),
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }

  Widget _buildReminderList(HomeViewModel model, BuildContext context) {
    model.getReminders(ReminderState.upcoming);
    List<Reminder> reminders = model.reminders;
    print('length: ${reminders.length}');
    if (reminders.isEmpty) {
      return Center(
        child: Text('No reminders.'),
      );
    }
    return ListView.builder(
      itemCount: reminders.length,
      itemBuilder: (context, index) {
        final reminder = reminders[index];

        return Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            left: 10.0,
            right: 10.0,
            bottom: 5.0,
          ),
          child: Container(
            color: Colors.black26,
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(reminder.text),
                    GestureDetector(
                      onTap: () => showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            child: ListView(
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.check),
                                  title: Text('Done'),
                                ),
                                ListTile(
                                  leading: Icon(Icons.alarm),
                                  title: Text('Postpone'),
                                ),
                                ListTile(
                                  leading: Icon(Icons.create),
                                  title: Text('Edit'),
                                ),
                                ListTile(
                                  leading: Icon(Icons.content_copy),
                                  title: Text('Copy'),
                                ),
                                ListTile(
                                  leading: Icon(Icons.share),
                                  title: Text('Share'),
                                ),
                                ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text('Delete'),
                                  onTap: () =>
                                      model.deleteReminder(reminder.id),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      child: Icon(
                        Icons.more_vert,
                        size: 18.0,
                      ),
                    )
                  ],
                ),
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.access_time,
                        size: 16.0,
                      ),
                      SizedBox(
                        width: 3.0,
                      ),
                      Text(reminder.time),
                      SizedBox(
                        width: 10.0,
                      ),
                      Icon(
                        Icons.calendar_today,
                        size: 16.0,
                      ),
                      SizedBox(
                        width: 3.0,
                      ),
                      Text(reminder.date),
                      SizedBox(
                        width: 10.0,
                      ),
                      Icon(
                        Icons.repeat,
                        size: 16.0,
                      ),
                      SizedBox(
                        width: 3.0,
                      ),
                      Text(reminder.repeat),
                    ],
                  ),
                  Icon(
                    Icons.star,
                    size: 18.0,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
