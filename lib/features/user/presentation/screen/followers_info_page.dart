import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../core/colors/app_colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/style_resource/custom_textstyle.dart';
import '../../../../core/utils/strings_manager.dart';
import '../../../../core/utils/toast_show.dart';
import '../../../../core/widget/custom_widgets/custom_circulars_progress.dart';
import '../../../../models/user_personal_info.dart';
import '../bloc/users_info_cubit.dart';
import '../widgets/show_me_the_users.dart';

class FollowersInfoPage extends StatefulWidget {
  final ValueNotifier<UserPersonalInfo> userInfo;
  final int initialIndex;
  final VoidCallback updateFollowersCallback;
  const FollowersInfoPage({
    super.key,
    required this.userInfo,
    this.initialIndex = 0,
    required this.updateFollowersCallback,
  });

  @override
  State<FollowersInfoPage> createState() => _FollowersInfoPageState();
}

class _FollowersInfoPageState extends State<FollowersInfoPage> {
  ValueNotifier<bool> rebuildUsersInfo = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialIndex,
      child: ValueListenableBuilder(
        valueListenable: widget.userInfo,
        builder: (context, UserPersonalInfo userInfoValue, child) => Scaffold(
          appBar: isThatMobile ? buildAppBar(context, userInfoValue) : null,
          body: ValueListenableBuilder(
            valueListenable: rebuildUsersInfo,
            builder: (context, bool rebuildValue, child) =>
                BlocBuilder<UsersInfoCubit, UsersInfoState>(
              bloc: BlocProvider.of<UsersInfoCubit>(context)
                ..getFollowersAndFollowingsInfo(
                    followersIds: userInfoValue.followerPeople,
                    followingsIds: userInfoValue.followedPeople),
              buildWhen: (previous, current) {
                if (previous != current &&
                    (current is CubitFollowersAndFollowingsLoaded)) {
                  return true;
                }
                if (rebuildValue &&
                    (current is CubitFollowersAndFollowingsLoaded)) {
                  rebuildUsersInfo.value = false;
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                if (state is CubitFollowersAndFollowingsLoaded) {
                  return _TapBarView(
                    state: state,
                    userInfo: widget.userInfo,
                    updateCallback: widget.updateFollowersCallback,
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
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context, UserPersonalInfo userInfoValue) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      bottom: TabBar(
        unselectedLabelColor: AppColors.grey,
        indicatorColor: Theme.of(context).focusColor,
        indicatorWeight: 1,
        tabs: [
          Tab(
              icon: buildText(context,
                  "${userInfoValue.followerPeople.length} ${StringsManager.followers.tr}")),
          Tab(
              icon: buildText(context,
                  "${userInfoValue.followedPeople.length} ${StringsManager.following.tr}")),
        ],
      ),
      title: buildText(context, userInfoValue.userName),
    );
  }

  Text buildText(BuildContext context, String text) {
    return Text(text,
        style: getNormalStyle(color: Theme.of(context).focusColor));
  }
}

class _TapBarView extends StatelessWidget {
  final CubitFollowersAndFollowingsLoaded state;
  final ValueNotifier<UserPersonalInfo> userInfo;
  final VoidCallback updateCallback;
  const _TapBarView({
    Key? key,
    required this.userInfo,
    required this.state,
    required this.updateCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isThatMyPersonalId = userInfo.value.userId == myPersonalId;

    return TabBarView(
      children: [
        SingleChildScrollView(
          child: ShowMeTheUsers(
            usersInfo: state.followersAndFollowingsInfo.followersInfo,
            emptyText: StringsManager.noFollowers.tr,
            isThatMyPersonalId: isThatMyPersonalId,
            updateFollowedCallback: updateCallback,
          ),
        ),
        SingleChildScrollView(
          child: ShowMeTheUsers(
            usersInfo: state.followersAndFollowingsInfo.followingsInfo,
            isThatFollower: false,
            emptyText: StringsManager.noFollowings.tr,
            isThatMyPersonalId: isThatMyPersonalId,
            updateFollowedCallback: updateCallback,
          ),
        ),
      ],
    );
  }
}
