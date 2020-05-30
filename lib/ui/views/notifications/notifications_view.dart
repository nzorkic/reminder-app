import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'notifications_viewmodel.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder: (context, model, child) => Scaffold(
              body: Center(
                child: Text('Notification view'),
              ),
            ),
        viewModelBuilder: () => NotificationsViewModel());
  }
}
