import 'package:ceo_events/core/get_it.dart';
import 'package:ceo_events/home/chat/chat.dart';
import 'package:ceo_events/service/service_manager.dart';
import 'package:ceo_events/viewmodel/chat/chat_view_model_list.dart';
import 'package:ceo_events/viewmodel/shuffle/shuffle_view_model.dart';
import 'package:ceo_events/viewmodel/shuffle/shuffle_view_model_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'dart:async';
import 'dart:ui';
import 'package:intl/intl.dart';

class ShuffleCard extends StatelessWidget {
  final ShuffleViewModel _user;
  final vm = getIt<ShufListState>();
  ShuffleCard({ShuffleViewModel user}) : this._user = user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        getIt<ChatListState>().messageList.clear();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChatView(
                  receiverID: _user.id,
                  clientName: _user.name,
                )));
        await ServiceManager.shared.fetchMessageList(_user.id);
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
            color: Colors.white,
            width: double.infinity,
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://yt3.ggpht.com/a/AATXAJymPwE0-PXbFjcJDrZ9unwi5qXZq3dWLB53ha7nwZw=s100-c-k-c0xffffffff-no-rj-mo")),
                              shape: BoxShape.circle,
                              color: Colors.blueGrey),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(children: [
                          Text(
                            _user.name,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Observer(
                            builder: (_) => Text(
                              vm.onlineUsers.contains(_user.id)
                                  ? 'Online'
                                  : 'Was in ' +
                                      DateFormat('yyyy-MM-dd hh:mm:ss')
                                          .format(DateTime.now()),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                          ),
                        ]),
                        Spacer(),
                        Observer(
                          builder: (_) => Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                                color: vm.onlineUsers.contains(_user.id)
                                    ? Colors.green
                                    : Colors.red,
                                shape: BoxShape.circle),
                          ),
                        ),
                      ]),
                ),
                Container(
                  color: Colors.black,
                  width: double.infinity,
                  height: 0.15,
                )
              ],
            )),
      ),
    );
  }
}
