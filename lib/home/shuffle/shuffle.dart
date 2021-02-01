import 'package:ceo_events/core/base_state.dart';
import 'package:ceo_events/core/get_it.dart';
import 'package:ceo_events/helper/preferences_helper.dart';
import 'package:ceo_events/helper/socket_helper.dart';
import 'package:ceo_events/home/shuffle/list.dart';
import 'package:ceo_events/viewmodel/shuffle/shuffle_view_model_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ShuffleView extends StatefulWidget {
  @override
  _ShuffleViewState createState() => _ShuffleViewState();
}

class _ShuffleViewState extends BaseState<ShuffleView> {
  var shuffleVM = getIt<ShufListState>();

  Widget _buildShuffleList(ShuffleListVM vm) {
    return Observer(builder: (context) {
      switch (vm.status) {
        case ListStatus.loading:
          return Center(child: CircularProgressIndicator());
          break;
        case ListStatus.loaded:
          return ShuffleList();
          break;
        case ListStatus.empty:
          return Center(
            child: Text("Data not available"),
          );
          break;
        default:
          return Container();
      }
    });
  }

  @override
  void initState() {
    SocketHelper.shared.connectSocket();
    shuffleVM.fetchUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Chats'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          // onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                await SharedPreferencesHelper.shared.removeToken();
                // Navigator.of(context).pushAndRemoveUntil(
                //     MaterialPageRoute(builder: (context) => SignInView()),
                //     (route) => false);
              })
        ],
      ),
      body: _buildShuffleList(shuffleVM),
    );
  }
}
