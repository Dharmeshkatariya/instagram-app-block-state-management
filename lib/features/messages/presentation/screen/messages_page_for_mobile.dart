import 'package:flutter/material.dart';
import 'package:instagram_dharmesh_bloc_demo/features/messages/presentation/screen/select_for_group_chat.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/routes/getnav.dart';
import '../widgets/list_of_messages.dart';

class MessagesPageForMobile extends StatelessWidget {
  const MessagesPageForMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isThatMobile ? buildAppBar(context) : null,
      body: const ListOfMessages(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        IconButton(
          onPressed: () {
            Go(context).push(page: const SelectForGroupChat());
          },
          icon: Icon(
            Icons.add,
            color: Theme.of(context).focusColor,
            size: 30,
          ),
        )
      ],
    );
  }
}
