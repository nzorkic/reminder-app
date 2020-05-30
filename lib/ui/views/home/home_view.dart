import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../global/locator.dart';
import '../../../global/router.gr.dart';

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
                Tab(text: "All", icon: Icon(Icons.assignment)),
                Tab(text: "Favorites", icon: Icon(Icons.star)),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Center(child: Text("All Tab")),
              Center(child: Text("Favorites Tab"))
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => locator<NavigationService>()
                .navigateTo(Routes.notificationsViewRoute),
            child: Icon(Icons.add),
          ),
        ),
      ),
      viewModelBuilder: () => BaseViewModel(),
    );
  }
}
