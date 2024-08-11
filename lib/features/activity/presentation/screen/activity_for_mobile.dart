import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/style_resource/custom_textstyle.dart';
import '../../../../core/utils/strings_manager.dart';
import '../../../../core/utils/toast_show.dart';
import '../../../../core/widget/custom_widgets/custom_circulars_progress.dart';
import '../../../../core/widget/others/notification_card_info.dart';
import '../../../../models/notification.dart';
import '../../../../models/user_personal_info.dart';
import '../../../notification/presentation/bloc/notification_cubit.dart';
import '../../../user/presentation/bloc/user_info_cubit.dart';
import '../../../user/presentation/bloc/user_info_state.dart';
import '../../../user/presentation/widgets/show_me_the_users.dart';


class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  late UserPersonalInfo myPersonalInfo;
  final ValueNotifier<bool> rebuildUsersInfo = ValueNotifier(false);

  @override
  void initState() {
    myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isThatMobile
        ? Scaffold(
            appBar: AppBar(title: Text(StringsManager.activity.tr)),
            body: buildBody(context),
          )
        : buildBody(context);
  }

  BlocBuilder<UserInfoCubit, UserInfoState> buildBody(BuildContext context) {
    return BlocBuilder<UserInfoCubit, UserInfoState>(
      bloc: UserInfoCubit.get(context)..getAllUnFollowersUsers(myPersonalInfo),
      buildWhen: (previous, current) =>
          (previous != current && current is CubitAllUnFollowersUserLoaded),
      builder: (context, unFollowersState) {
        return BlocBuilder<NotificationCubit, NotificationState>(
          bloc: NotificationCubit.get(context)
            ..getNotifications(userId: myPersonalId),
          buildWhen: (previous, current) =>
              (previous != current && current is NotificationLoaded),
          builder: (context, notificationState) {
            if (unFollowersState is CubitAllUnFollowersUserLoaded &&
                notificationState is NotificationLoaded) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (notificationState.notifications.isNotEmpty)
                      _ShowNotifications(
                        notifications: notificationState.notifications,
                      ),
                    if (unFollowersState.usersInfo.isNotEmpty) ...[
                      suggestionForYouText(context),
                      ShowMeTheUsers(
                        usersInfo: unFollowersState.usersInfo,
                        showColorfulCircle: false,
                        emptyText: StringsManager.noActivity.tr,
                        isThatMyPersonalId: true,
                      ),
                    ],
                  ],
                ),
              );
            } else if (notificationState is NotificationFailed &&
                unFollowersState is CubitAllUnFollowersUserLoaded) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    suggestionForYouText(context),
                    ShowMeTheUsers(
                      usersInfo: unFollowersState.usersInfo,
                      showColorfulCircle: false,
                      emptyText: StringsManager.noActivity.tr,
                      isThatMyPersonalId: true,
                    ),
                  ],
                ),
              );
            } else if (unFollowersState is CubitGetUserInfoFailed &&
                notificationState is NotificationLoaded) {
              return SingleChildScrollView(
                child: _ShowNotifications(
                  notifications: notificationState.notifications,
                ),
              );
            } else if (notificationState is NotificationFailed &&
                unFollowersState is CubitGetUserInfoFailed) {
              ToastShow.toast(notificationState.error);
              return Center(
                child: Text(
                  StringsManager.somethingWrong.tr,
                  style: getNormalStyle(color: Theme.of(context).focusColor),
                ),
              );
            }
            return const Center(child: ThineCircularProgress());
          },
        );
      },
    );
  }

  Padding suggestionForYouText(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(15),
      child: Text(
        StringsManager.suggestionsForYou.tr,
        style:
            getMediumStyle(color: Theme.of(context).focusColor, fontSize: 16),
      ),
    );
  }
}

class _ShowNotifications extends StatefulWidget {
  final List<CustomNotification> notifications;

  const _ShowNotifications({Key? key, required this.notifications})
      : super(key: key);

  @override
  State<_ShowNotifications> createState() => _ShowNotificationsState();
}

class _ShowNotificationsState extends State<_ShowNotifications> {
  late UserPersonalInfo myPersonalInfo;

  @override
  initState() {
    myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.notifications.isNotEmpty) {
      return ListView.separated(
        shrinkWrap: true,
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        itemBuilder: (context, index) {
          return NotificationCardInfo(
              notificationInfo: widget.notifications[index]);
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: widget.notifications.length,
      );
    } else {
      return Center(
        child: Text(
          StringsManager.noActivity.tr,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }
  }
}
