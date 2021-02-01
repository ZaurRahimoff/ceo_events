import 'package:ceo_events/core/get_it.dart';
import 'package:ceo_events/home/shuffle/card.dart';
import 'package:ceo_events/viewmodel/shuffle/shuffle_view_model_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ShuffleList extends StatelessWidget {
  final vm = getIt<ShufListState>();

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => ListView.builder(
        itemCount: vm.userList.length,
        itemBuilder: (context, index) {
          return ShuffleCard(
            user: vm.userList[index],
          );
        },
      ),
    );
  }
}
