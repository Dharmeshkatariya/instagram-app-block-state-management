import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/strings_manager.dart';
import '../../../../core/utils/toast_show.dart';
import '../../../../core/widget/custom_widgets/custom_circulars_progress.dart';
import '../bloc/users_info_cubit.dart';
import '../widgets/show_me_the_users.dart';

class UsersWhoLikes extends StatelessWidget {
  final List<dynamic> usersIds;
  final bool showSearchBar;
  final bool showColorfulCircle;
  final bool isThatMyPersonalId;

  const UsersWhoLikes({
    Key? key,
    required this.showSearchBar,
    required this.usersIds,
    required this.isThatMyPersonalId,
    this.showColorfulCircle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<UsersInfoCubit>(context)
        ..getSpecificUsersInfo(usersIds: usersIds),
      buildWhen: (previous, current) =>
          previous != current && current is CubitGettingSpecificUsersLoaded,
      builder: (context, state) {
        if (state is CubitGettingSpecificUsersLoaded) {
          return ShowMeTheUsers(
            usersInfo: state.specificUsersInfo,
            emptyText: StringsManager.noUsers.tr,
            showColorfulCircle: showColorfulCircle,
            isThatMyPersonalId: isThatMyPersonalId,
          );
        }
        if (state is CubitGettingSpecificUsersFailed) {
          ToastShow.toastStateError(state);
          return Center(
            child: Text(StringsManager.somethingWrong.tr,
                style: Theme.of(context).textTheme.bodyLarge),
          );
        } else {
          return const Center(child: ThineCircularProgress());
        }
      },
    );
  }
}
