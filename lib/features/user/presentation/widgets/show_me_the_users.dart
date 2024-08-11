import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:instagram_dharmesh_bloc_demo/features/user/presentation/widgets/which_profile_page.dart';

import '../../../../core/colors/app_colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/routes/getnav.dart';
import '../../../../core/utils/strings_manager.dart';
import '../../../../core/utils/toast_show.dart';
import '../../../../core/widget/circle_avatar_image/circle_avatar_of_profile_image.dart';
import '../../../../models/user_personal_info.dart';
import '../bloc/follow/follow_cubit.dart';
import '../bloc/user_info_cubit.dart';
import '../bloc/users_info_reel_time/users_info_reel_time_bloc.dart';

class ShowMeTheUsers extends StatefulWidget {
  final List<UserPersonalInfo> usersInfo;
  final bool isThatFollower;
  final bool showColorfulCircle;
  final String emptyText;
  final bool isThatMyPersonalId;
  final VoidCallback? updateFollowedCallback;

  const ShowMeTheUsers({
    super.key,
    this.updateFollowedCallback,
    required this.isThatMyPersonalId,
    this.showColorfulCircle = true,
    this.isThatFollower = true,
    required this.usersInfo,
    required this.emptyText,
  });

  @override
  State<ShowMeTheUsers> createState() => _ShowMeTheUsersState();
}

class _ShowMeTheUsersState extends State<ShowMeTheUsers> {
  @override
  Widget build(BuildContext context) {
    if (widget.usersInfo.isNotEmpty) {
      return SingleChildScrollView(
        child: ListView.separated(
          shrinkWrap: true,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          addAutomaticKeepAlives: false,
          itemBuilder: (context, index) {
            return containerOfUserInfo(
                widget.usersInfo[index], widget.isThatFollower);
          },
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemCount: widget.usersInfo.length,
        ),
      );
    } else {
      return Center(
        child: Text(
          widget.emptyText,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }
  }

  Widget containerOfUserInfo(UserPersonalInfo userInfo, bool isThatFollower) {
    String hash = "${userInfo.userId.hashCode}userInfo";

    return InkWell(
      onTap: () async {
        Navigator.of(context).maybePop();
        await Go(context).push(
            page: WhichProfilePage(userId: userInfo.userId),
            withoutRoot: false);
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 15, top: 15),
        child: Row(children: [
          Hero(
            tag: hash,
            child: CircleAvatarOfProfileImage(
              bodyHeight: 600,
              hashTag: hash,
              userInfo: userInfo,
              showColorfulCircle: widget.showColorfulCircle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userInfo.userName,
                  style: Theme.of(context).textTheme.displayMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 5),
                Text(
                  userInfo.name,
                  style: Theme.of(context).textTheme.displayLarge,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                )
              ],
            ),
          ),
          // const Spacer(),
          followButton(userInfo),
        ]),
      ),
    );
  }

  Widget followButton(UserPersonalInfo userInfo) {
    return BlocBuilder<FollowCubit, FollowState>(
      builder: (followContext, stateOfFollow) {
        return Builder(
          builder: (userContext) {
            UserPersonalInfo myPersonalInfo =
                UserInfoCubit.getMyPersonalInfo(context);
            UserPersonalInfo? info =
                UsersInfoReelTimeBloc.getMyInfoInReelTime(context);
            if (isMyInfoInReelTimeReady && info != null) myPersonalInfo = info;

            if (myPersonalId == userInfo.userId) {
              return Container();
            } else {
              return GestureDetector(
                  onTap: () async {
                    if (myPersonalInfo.followedPeople
                        .contains(userInfo.userId)) {
                      await BlocProvider.of<FollowCubit>(followContext)
                          .unFollowThisUser(
                              followingUserId: userInfo.userId,
                              myPersonalId: myPersonalId);
                      if (!mounted) return;
                      BlocProvider.of<UserInfoCubit>(context)
                          .updateMyFollowings(
                              userId: userInfo.userId, addThisUser: false);
                    } else {
                      await BlocProvider.of<FollowCubit>(followContext)
                          .followThisUser(
                              followingUserId: userInfo.userId,
                              myPersonalId: myPersonalId);
                      if (!mounted) return;

                      BlocProvider.of<UserInfoCubit>(context)
                          .updateMyFollowings(userId: userInfo.userId);
                    }
                  },
                  child: whichContainerOfText(
                      stateOfFollow, userInfo, myPersonalInfo));
            }
          },
        );
      },
    );
  }

  Widget whichContainerOfText(FollowState stateOfFollow,
      UserPersonalInfo userInfo, UserPersonalInfo myPersonalInfo) {
    if (stateOfFollow is CubitFollowThisUserFailed) {
      ToastShow.toastStateError(stateOfFollow);
    }

    return !myPersonalInfo.followedPeople.contains(userInfo.userId)
        ? containerOfFollowText(
            text: StringsManager.follow.tr,
            isThatFollower: false,
          )
        : containerOfFollowText(
            text: StringsManager.following.tr,
            isThatFollower: true,
          );
  }

  Widget containerOfFollowText(
      {required String text, required bool isThatFollower}) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 45, end: 15),
      child: Container(
        height: 32.0,
        decoration: BoxDecoration(
          color:
              isThatFollower ? Theme.of(context).primaryColor : AppColors.blue,
          border: isThatFollower
              ? Border.all(
                  color: Theme.of(context).bottomAppBarTheme.color!, width: 1.0)
              : null,
          borderRadius: BorderRadius.circular(isThatMobile ? 15 : 5),
        ),
        child: Center(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: isThatFollower ? 10.0 : 22),
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 17.0,
                  color: isThatFollower
                      ? Theme.of(context).focusColor
                      : AppColors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
