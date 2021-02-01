import 'package:flutter/material.dart';
import 'package:ceo_events/home/home.dart';

class ChatMainPage extends StatelessWidget {
  static const String routeName = '/chatmainpage';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("ChatMainPage"),
        ),
        drawer: AppDrawer(),
        body: Center(child: Text("ChatMainPage")));
  }
}