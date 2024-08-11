import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../features/user/presentation/bloc/users_info_cubit.dart';
import '../../../../features/user/presentation/widgets/show_me_the_users.dart';
import '../../../utils/strings_manager.dart';
import '../../../utils/toast_show.dart';
import '../../custom_widgets/custom_circulars_progress.dart';

class GetUsersInfo extends StatefulWidget {
  final List<dynamic> usersIds;
  final bool isThatFollowers;
  final bool isThatMyPersonalId;

  const GetUsersInfo({
    super.key,
    required this.isThatMyPersonalId,
    required this.usersIds,
    this.isThatFollowers = true,
  });

  @override
  State<GetUsersInfo> createState() => _GetUsersInfoState();
}

class _GetUsersInfoState extends State<GetUsersInfo> {
  ValueNotifier<bool> rebuildUsersInfo = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: rebuildUsersInfo,
      builder: (context, bool rebuildValue, child) =>
          BlocBuilder<UsersInfoCubit, UsersInfoState>(
        bloc: BlocProvider.of<UsersInfoCubit>(context)
          ..getSpecificUsersInfo(usersIds: widget.usersIds),
        buildWhen: (previous, current) {
          if (previous != current &&
              (current is CubitGettingSpecificUsersLoaded)) {
            return true;
          }
          if (rebuildValue && (current is CubitGettingSpecificUsersLoaded)) {
            rebuildUsersInfo.value = false;
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is CubitGettingSpecificUsersLoaded) {
            return ShowMeTheUsers(
              usersInfo: state.specificUsersInfo,
              emptyText: widget.isThatFollowers
                  ? StringsManager.noFollowers.tr
                  : StringsManager.noFollowings.tr,
              isThatMyPersonalId: widget.isThatMyPersonalId,
            );
          }
          if (state is CubitGettingSpecificUsersFailed) {
            ToastShow.toastStateError(state);
            return Text(StringsManager.somethingWrong.tr);
          } else {
            return const ThineCircularProgress();
          }
        },
      ),
    );
  }
}
