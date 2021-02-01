import 'dart:ui';

import 'package:ceo_events/configs/events_exception.dart';
import 'package:ceo_events/home/detail_page.dart';
import 'package:ceo_events/models/event.dart';
import 'package:ceo_events/routes/routes.dart';
import 'package:ceo_events/service/app_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final eventsFutureProvider1 =
    FutureProvider.autoDispose<List<Event>>((ref) async {
  ref.maintainState = true;

  final eventService = ref.read(eventServiceProvider);
  final events = await eventService.getEvents();

  final statusComplete1 = events.where((i) => i.type == 'exhibition').toList();

  for (int i = 0; i < statusComplete1.length; i++) {
    print('This is the list for true status :${statusComplete1[i].title}');
  }

  return statusComplete1;
});

final eventsFutureProvider2 =
    FutureProvider.autoDispose<List<Event>>((ref) async {
  ref.maintainState = true;

  final eventService = ref.read(eventServiceProvider);
  final events = await eventService.getEvents();

  final statusComplete2 = events.where((i) => i.type == 'conference').toList();

  for (int i = 0; i < statusComplete2.length; i++) {
    print('This is the list for true status :${statusComplete2[i].title}');
  }

  return statusComplete2;
});

class HomePage extends ConsumerWidget {
  final Event event;

  const HomePage({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    double c_width = MediaQuery.of(context).size.width * 0.8;

    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    var apstr = [eventsFutureProvider1, eventsFutureProvider2];

    return DefaultTabController(
        length: apstr.length,
        child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.white,
          drawer: AppDrawer(),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              padding: EdgeInsets.symmetric(horizontal: 16),
              icon: Image.network(
                  'https://img.icons8.com/ios-filled/50/000000/menu-rounded.png'),
              onPressed: () {
                _scaffoldKey.currentState.openDrawer();
              },
            ),
            actions: <Widget>[
              IconButton(
                padding: EdgeInsets.symmetric(horizontal: 20),
                icon: Image.network(
                    'https://img.icons8.com/ios/50/000000/star--v1.png'),
                onPressed: () {},
              ),
            ],
            title: Expanded(
              child: Row(
                children: [
                  // Image.network(
                  //   'https://exhibitions.ceo.az/images/logo.png', width: 30),
                  Text(
                    'Events list',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            bottom: TabBar(
                unselectedLabelColor: Colors.redAccent,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.redAccent),
                tabs: [
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border:
                              Border.all(color: Colors.transparent, width: 1)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Exhibitions"),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border:
                              Border.all(color: Colors.transparent, width: 1)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Conferences"),
                      ),
                    ),
                  ),
                ]),
          ),
          body: TabBarView(
            children: <Widget>[
              watch(eventsFutureProvider1).when(
                  error: (e, s) {
                    if (e is EventsException) {
                      return _ErrorBody(message: e.message);
                    }
                    return _ErrorBody(
                        message: "Oops, something unexpected happened");
                  },
                  loading: () => Center(child: CircularProgressIndicator()),
                  data: (statusComplete1) {
                    return RefreshIndicator(
                      onRefresh: () {
                        return context.refresh(eventsFutureProvider1);
                      },
                      child: Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.all(10.0),
                          itemCount: statusComplete1.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkResponse(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => DetailPage(
                                        event: statusComplete1[index])),
                              ),
                              child: Card(
                                elevation: 10,
                                margin: new EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 6.0),
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Flexible(
                                            child: Card(
                                              elevation: 0,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Hero(
                                                    tag: statusComplete1[index]
                                                        .logo,
                                                    child: Image.network(
                                                        statusComplete1[index]
                                                            .logo,
                                                        alignment:
                                                            Alignment.topLeft),
                                                  ),
                                                  SizedBox(
                                                    height: 15.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 250,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10.0, right: 0),
                                              child: Flexible(
                                                child: Card(
                                                  elevation: 0,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        statusComplete1[index]
                                                            .title
                                                            .replaceAll(
                                                                '<br/>', ''),
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        DateFormat.yMMMd().format(
                                            statusComplete1[index].beginDate),
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
              watch(eventsFutureProvider2).when(
                  error: (e, s) {
                    if (e is EventsException) {
                      return _ErrorBody(message: e.message);
                    }
                    return _ErrorBody(
                        message: "Oops, something unexpected happened");
                  },
                  loading: () => Center(child: CircularProgressIndicator()),
                  data: (statusComplete2) {
                    return RefreshIndicator(
                      onRefresh: () {
                        return context.refresh(eventsFutureProvider2);
                      },
                      child: Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.all(10.0),
                          itemCount: statusComplete2.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 10,
                              margin: new EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Flexible(
                                          child: Card(
                                            elevation: 0,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                CircleAvatar(
                                                  child: Image.network(
                                                      statusComplete2[index]
                                                          .logo,
                                                      alignment:
                                                          Alignment.topLeft),
                                                  backgroundColor: Colors.white,
                                                  maxRadius: 40,
                                                ),
                                                SizedBox(
                                                  height: 15.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 250,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 10.0, right: 0),
                                            child: Flexible(
                                              child: Card(
                                                elevation: 0,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      statusComplete2[index]
                                                          .title
                                                          .replaceAll(
                                                              '<br/>', ''),
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      statusComplete2[index].type,
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ));
  }
}

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
              icon: Icons.contacts,
              text: 'ChatMainPage',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.chatmainpage)),
          // _createDrawerItem(icon: Icons.event, text: 'Events',),
          // _createDrawerItem(icon: Icons.note, text: 'Notes',),
          // Divider(),
          // _createDrawerItem(icon: Icons.collections_bookmark, text: 'Steps'),
          // _createDrawerItem(icon: Icons.face, text: 'Authors'),
          // _createDrawerItem(icon: Icons.account_box, text: 'Flutter Documentation'),
          // _createDrawerItem(icon: Icons.stars, text: 'Useful Links'),
          // Divider(),
          // _createDrawerItem(icon: Icons.bug_report, text: 'Report an issue'),
          ListTile(
            title: Text('0.0.1'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

Widget _createHeader() {
  return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('path/to/header_background.png'))),
      child: Stack(children: <Widget>[
        Positioned(
            bottom: 12.0,
            left: 16.0,
            child: Text("Flutter Step-by-Step",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500))),
      ]));
}

Widget _createDrawerItem(
    {IconData icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(text),
        )
      ],
    ),
    onTap: onTap,
  );
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({
    Key key,
    @required this.message,
  })  : assert(message != null, 'A non-null String must be provided'),
        super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          ElevatedButton(
            onPressed: () => context.refresh(eventsFutureProvider1),
            child: Text("Try again"),
          ),
        ],
      ),
    );
  }
}
