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
          drawer: _buildDrawer(),
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

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Container(
              color: Colors.cyan,
            ),
          ),
          ListTile(
            leading: Opacity(
              opacity: .7,
              child: Icon(Icons.check_box),
            ),
            title: Text('Done'),
            trailing: Text('72'),
          ),
          ListTile(
            leading: Opacity(
              opacity: .7,
              child: Icon(Icons.assignment),
            ),
            title: Text('Today'),
            trailing: Text('1'),
          ),
          ListTile(
            leading: Opacity(
              opacity: .7,
              child: Icon(Icons.assignment),
            ),
            title: Text('Upcoming'),
            trailing: Text('3'),
          ),
          Divider(),
          ListTile(
            leading: Opacity(
              opacity: .7,
              child: Icon(Icons.settings),
            ),
            title: Text('Settings'),
          ),
          ListTile(
            leading: Opacity(
              opacity: .7,
              child: Icon(Icons.info),
            ),
            title: Text('About'),
          ),
          ListTile(
            leading: Opacity(
              opacity: .7,
              child: Icon(Icons.help),
            ),
            title: Text('Help'),
          ),
          ListTile(
            leading: Opacity(
              opacity: .7,
              child: Icon(Icons.feedback),
            ),
            title: Text('Feedback'),
          ),
          Divider(),
          ListTile(
            leading: Opacity(
              opacity: .7,
              child: Icon(Icons.local_activity),
            ),
            title: Text('Remove Ads'),
          ),
          ListTile(
            leading: Opacity(
              opacity: .7,
              child: Icon(Icons.share),
            ),
            title: Text('Share the app'),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderList(HomeViewModel model, BuildContext context) {
    return FutureBuilder(
      future: model.getUpcomingReminders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none &&
            snapshot.hasData == false) {
          return Center(
            child: Text('There are no reminders'),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            debugPrint(snapshot.error.toString());
            return Center(child: Text("There was an error."));
          }
          return SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  _buildListSection(
                      model, snapshot.data[ReminderState.today], 'Today'),
                  _buildListSection(
                      model, snapshot.data[ReminderState.upcoming], 'Upcoming'),
                ],
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildListSection(
      HomeViewModel model, List<Reminder> reminders, String sectionTitle) {
    return reminders.isEmpty
        ? Container()
        : Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.assignment),
                title: Text(sectionTitle),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  final reminder = reminders[index];

                  return Padding(
                    padding: const EdgeInsets.only(
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
                                onTap: () => _buildBottomSheetModal(
                                    context, model, reminder),
                                child: Icon(
                                  Icons.more_vert,
                                  size: 18.0,
                                ),
                              )
                            ],
                          ),
                        ),
                        subtitle: _buildTileSubtitle(reminder),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
  }

  _buildBottomSheetModal(context, model, reminder) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.check),
                title: Text('Done'),
                onTap: () => model.onDone(reminder),
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
                onTap: () => model.onDelete(reminder.id),
              ),
            ],
          ),
        );
      },
    );
  }

  Row _buildTileSubtitle(reminder) {
    return Row(
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
    );
  }
}
