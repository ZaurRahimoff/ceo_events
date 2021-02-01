import 'package:ceo_events/helper/preferences_helper.dart';
import 'package:ceo_events/home/shuffle/shuffle.dart';
import 'package:flutter/material.dart';
import 'package:ceo_events/home/chat_main_page.dart';
import 'package:ceo_events/routes/routes.dart';

import 'core/get_it.dart';
import 'home/home.dart';

void shuffle() {
  SharedPreferencesHelper.shared.userControl(completionHandler: (status) {
    ShuffleView();
  });
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Events list',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        Routes.chatmainpage: (context) => ShuffleView(),
      },
    );
  }
}
