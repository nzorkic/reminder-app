import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../global/locator.dart';
import 'notifications_viewmodel.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(
                leading: GestureDetector(
                  child: Icon(Icons.arrow_back),
                  onTap: locator<NavigationService>().back,
                ),
              ),
              body: _NotificationViewBody(),
            ),
        viewModelBuilder: () => NotificationsViewModel());
  }
}

class _NotificationViewBody extends ViewModelWidget<NotificationsViewModel> {
  @override
  Widget build(BuildContext context, NotificationsViewModel viewModel) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _ValueDashboard(),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 50.0),
            child: Column(children: <Widget>[
              _buildParameter(
                  Icons.calendar_today, Colors.blue, 'Date', '30.5.2020'),
              _buildParameter(
                  Icons.access_time, Colors.purple, 'Time', '17:00'),
              _buildParameter(Icons.repeat, Colors.green, 'Repeat', 'Once'),
              _buildParameter(
                  Icons.color_lens, Colors.red, 'Marker', 'No Marker'),
              _buildParameter(Icons.add_alert, Colors.deepPurple, 'Report as',
                  'Notification'),
              _buildParameter(Icons.av_timer, Colors.grey, 'Notifi in advance',
                  'Not specified'),
            ]),
          ),
        ],
      ),
    );
  }

  ListTile _buildParameter(
      IconData icon, Color iconColor, String text, String value) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor,
      ),
      title: Text(text),
      trailing: Text(value),
    );
  }
}

class _ValueDashboard extends HookViewModelWidget<NotificationsViewModel> {
  const _ValueDashboard({Key key}) : super(key: key, reactive: false);

  @override
  Widget buildViewModelWidget(
      BuildContext context, NotificationsViewModel viewModel) {
    var _text = TextEditingController();
    return Container(
      height: 125,
      color: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _text,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Remind me to...',
                fillColor: Colors.black,
                border: InputBorder.none,
              ),
            ),
            Divider(
              color: Colors.black45,
            ),
            _buildInputOptions(),
          ],
        ),
      ),
    );
  }

  Container _buildInputOptions() {
    return Container(
      child: Row(
        children: <Widget>[
          _buildInputOption(Icons.mic, null),
          _buildInputOption(Icons.phone, null),
          _buildInputOption(Icons.portrait, null),
          _buildInputOption(Icons.keyboard, null),
        ],
      ),
    );
  }

  Padding _buildInputOption(IconData icon, Function action) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        child: Icon(icon),
        onTap: action,
      ),
    );
  }
}
