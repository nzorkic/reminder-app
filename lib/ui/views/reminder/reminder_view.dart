import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../global/locator.dart';
import '../../../services/notification_service.dart';
import 'reminder_viewmodel.dart';

class ReminderView extends StatelessWidget {
  const ReminderView({Key key}) : super(key: key);

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
        viewModelBuilder: () => ReminderViewModel());
  }
}

class _NotificationViewBody extends ViewModelWidget<ReminderViewModel> {
  @override
  Widget build(BuildContext context, ReminderViewModel viewModel) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _ValueDashboard(),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 50.0),
            child: Column(children: <Widget>[
              _buildParameter(
                  context,
                  viewModel.chooseDate,
                  Icons.calendar_today,
                  Colors.blue,
                  'Date',
                  viewModel.selectedDate),
              _buildParameter(
                  context,
                  viewModel.chooseTime,
                  Icons.access_time,
                  Colors.purple,
                  'Time',
                  viewModel.formattedTime),
              _buildParameter(context, viewModel.chooseDate, Icons.repeat,
                  Colors.green, 'Repeat', 'Once'),
              _buildParameter(context, viewModel.chooseDate,
                  Icons.color_lens, Colors.red, 'Marker', 'No Marker'),
              _buildParameter(context, viewModel.chooseDate,
                  Icons.add_alert, Colors.yellow, 'Report as', 'Notification'),
              _buildParameter(context, viewModel.chooseDate, Icons.av_timer,
                  Colors.grey, 'Notify in advance', 'Not specified'),
            ]),
          ),
        ],
      ),
    );
  }

  ListTile _buildParameter(BuildContext context, Function action, IconData icon,
      Color iconColor, String text, String value) {
    return ListTile(
        leading: Icon(
          icon,
          color: iconColor,
        ),
        title: Text(text),
        trailing: Text(value),
        onTap: () => action(context));
  }
}

class _ValueDashboard extends HookViewModelWidget<ReminderViewModel> {
  const _ValueDashboard({Key key}) : super(key: key, reactive: false);

  @override
  Widget buildViewModelWidget(
      BuildContext context, ReminderViewModel viewModel) {
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
              autofocus: false,
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
          _buildInputOption(Icons.keyboard,
              () => locator<NotificationService>().showNotification()),
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