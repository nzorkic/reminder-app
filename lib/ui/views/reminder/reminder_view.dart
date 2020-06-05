import 'package:flutter/material.dart';
import 'package:reminder_app/models/reminder.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../global/locator.dart';
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
        body: _ReminderViewBody(),
      ),
      viewModelBuilder: () => ReminderViewModel(),
    );
  }
}

class _ReminderViewBody extends ViewModelWidget<ReminderViewModel> {
  @override
  Widget build(BuildContext context, ReminderViewModel viewModel) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _ValueDashboard(),
          Align(
              alignment: Alignment(.75, 1),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: RaisedButton(
                    onPressed: () {
                      if (viewModel.reminderText.isEmpty) {
                        locator<DialogService>().showDialog(
                            title: 'Whoops',
                            description: 'Looks like you forgot to add text');
                      } else {
                        viewModel.generateReminder();
                      }
                    },
                    child: Icon(Icons.check),
                    color: Colors.green[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )),
              )),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0),
            child: Column(children: <Widget>[
              _buildParameter(
                context,
                viewModel.chooseDate,
                Icons.calendar_today,
                Colors.blue,
                'Date',
                Text(viewModel.selectedDate),
              ),
              _buildParameter(
                context,
                viewModel.chooseTime,
                Icons.access_time,
                Colors.purple,
                'Time',
                Text(viewModel.formattedTime),
              ),
              _buildParameter(
                context,
                viewModel.chooseRepeat,
                Icons.repeat,
                Colors.green,
                'Repeat',
                Text(
                  Repeat.values[viewModel.selectedRepeat].asString(),
                ),
              ),
              _buildParameter(
                context,
                viewModel.chooseMarker,
                Icons.color_lens,
                Colors.red,
                'Marker',
                Container(
                  width: 20.0,
                  height: 20.0,
                  decoration: new BoxDecoration(
                    color: viewModel.selectedMarker,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Opacity(
                opacity: .5,
                child: IgnorePointer(
                  child: _buildParameter(
                    context,
                    viewModel.chooseDate,
                    Icons.add_alert,
                    Colors.yellow,
                    'Report as',
                    Text('Notification'),
                  ),
                ),
              ),
              Opacity(
                opacity: .5,
                child: IgnorePointer(
                  child: _buildParameter(
                    context,
                    viewModel.dropTable,
                    Icons.av_timer,
                    Colors.grey,
                    'Notify in advance',
                    Text('Not specified'),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  ListTile _buildParameter(BuildContext context, Function action, IconData icon,
      Color iconColor, String text, Widget trailing) {
    return ListTile(
        leading: Icon(
          icon,
          color: iconColor,
        ),
        title: Text(text),
        trailing: trailing,
        onTap: () => action(context));
  }
}

class _ValueDashboard extends HookViewModelWidget<ReminderViewModel> {
  const _ValueDashboard({Key key}) : super(key: key, reactive: false);

  @override
  Widget buildViewModelWidget(
      BuildContext context, ReminderViewModel viewModel) {
    var _text = TextEditingController();
    _text.text = viewModel.reminderText;
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
              onChanged: (text) => viewModel.reminderValueChanged(text),
            ),
            Divider(
              color: Colors.black45,
            ),
            Opacity(
              opacity: .5,
              child: IgnorePointer(
                child: _buildInputOptions(),
              ),
            ),
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
