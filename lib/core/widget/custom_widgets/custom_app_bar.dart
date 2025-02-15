import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_dharmesh_bloc_demo/models/user_personal_info.dart';
import '../../../core/asset/asset.dart';
import '../../../core/routes/getnav.dart';
import '../../../core/widget/animated_instagram_logo.dart';
import '../../../features/activity/presentation/screen/activity_for_mobile.dart';
import '../../../features/messages/presentation/screen/messages_page_for_mobile.dart';
import '../../../features/messages/presentation/screen/wait_call_page.dart';
import '../../../features/user/presentation/bloc/user_info_cubit.dart';
import '../../../features/user/presentation/bloc/users_info_cubit.dart';
import '../../../features/user/presentation/bloc/users_info_reel_time/users_info_reel_time_bloc.dart';
import '../../../injection_container.dart';
import '../../constants/constants.dart';
import '../../style_resource/custom_textstyle.dart';
import '../circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'custom_gallery_display.dart';

class CustomAppBar {
  static AppBar basicAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: false,
      iconTheme: IconThemeData(color: Theme.of(context).focusColor),
      title: const InstagramLogo(),
      actions: [
        _addList(context),
        _favoriteButton(context),
        _messengerButton(context),
        const SizedBox(width: 5),
      ],
    );
  }

  static Widget _messengerButton(BuildContext context) {
    return BlocBuilder<UsersInfoReelTimeBloc, UsersInfoReelTimeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsetsDirectional.only(end: 5.0),
          child: GestureDetector(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  messengerIcon,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).focusColor, BlendMode.srcIn),
                  height: 22.5,
                ),
                if (state is MyPersonalInfoLoaded &&
                    state.myPersonalInfoInReelTime.numberOfNewMessages > 0)
                  _redPoint(),
              ],
            ),
            onTap: () {
              Go(context).push(
                  page: BlocProvider<UsersInfoCubit>(
                create: (context) => locator<UsersInfoCubit>(),
                child: const MessagesPageForMobile(),
              ));
            },
          ),
        );
      },
    );
  }

  static Positioned _redPoint() {
    return Positioned(
      right: 1.5,
      top: 15,
      child: Container(
        width: 10,
        height: 10,
        decoration:
            const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
      ),
    );
  }

  static Widget _favoriteButton(BuildContext context) {
    return BlocBuilder<UsersInfoReelTimeBloc, UsersInfoReelTimeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsetsDirectional.only(end: 13.0),
          child: GestureDetector(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  favorite,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).focusColor, BlendMode.srcIn),
                  height: 30,
                ),
                if (state is MyPersonalInfoLoaded &&
                    state.myPersonalInfoInReelTime.numberOfNewNotifications > 0)
                  _redPoint(),
              ],
            ),
            onTap: () {
              Go(context).push(page: const ActivityPage(), withoutRoot: false);
            },
          ),
        );
      },
    );
  }

  static GestureDetector _addList(BuildContext context) {
    return GestureDetector(
      onTap: () => _pushToCustomGallery(context),
      child: Padding(
        padding: const EdgeInsetsDirectional.only(end: 13.0),
        child: SvgPicture.asset(
          add2Icon,
          colorFilter:
              ColorFilter.mode(Theme.of(context).focusColor, BlendMode.srcIn),
          height: 22.5,
        ),
      ),
    );
  }

  static Future<void> _pushToCustomGallery(BuildContext context) async {
    await CustomImagePickerPlus.pickFromBoth(context);
  }

  static AppBar chattingAppBar(
      List<UserPersonalInfo> usersInfo, BuildContext context) {
    int length = usersInfo.length;
    length = length >= 3 ? 3 : length;
    return AppBar(
      iconTheme: IconThemeData(color: Theme.of(context).focusColor),
      backgroundColor: Theme.of(context).primaryColor,
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            if (length > 1) ...[
              _imagesOfGroupUsers(usersInfo)
            ] else ...[
              CircleAvatarOfProfileImage(
                  userInfo: usersInfo[0],
                  bodyHeight: 340,
                  showColorfulCircle: false),
            ],
            const SizedBox(width: 15),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...List.generate(1, (index) {
                  return Text(
                    "${usersInfo[index].name}${length > 1 ? ", ..." : ""}",
                    style: TextStyle(
                        color: Theme.of(context).focusColor,
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
      actions: [
        GestureDetector(
          child: SvgPicture.asset(
            phone,
            height: 27,
            colorFilter:
                ColorFilter.mode(Theme.of(context).focusColor, BlendMode.srcIn),
          ),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () async {
            UserPersonalInfo myPersonalInfo =
                UserInfoCubit.getMyPersonalInfo(context);
            amICalling = true;
            await Go(context).push(
                page: VideoCallPage(
                    usersInfo: usersInfo, myPersonalInfo: myPersonalInfo),
                withoutRoot: false,
                withoutPageTransition: true);
            amICalling = false;
          },
          child: SvgPicture.asset(
            videoPoint,
            height: 25,
            colorFilter:
                ColorFilter.mode(Theme.of(context).focusColor, BlendMode.srcIn),
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  static Stack _imagesOfGroupUsers(List<UserPersonalInfo> userInfo) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 10,
          top: -6,
          child: CircleAvatarOfProfileImage(
            bodyHeight: 280,
            userInfo: userInfo[0],
            showColorfulCircle: false,
            disablePressed: false,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: CircleAvatarOfProfileImage(
            bodyHeight: 280,
            userInfo: userInfo[1],
            showColorfulCircle: false,
            disablePressed: false,
          ),
        ),
      ],
    );
  }

  static AppBar oneTitleAppBar(BuildContext context, String text,
      {bool logoOfInstagram = false}) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: false,
      iconTheme: IconThemeData(color: Theme.of(context).focusColor),
      title: logoOfInstagram
          ? const InstagramLogo()
          : Text(
              text,
              style: getMediumStyle(
                  color: Theme.of(context).focusColor, fontSize: 20),
            ),
    );
  }

  static AppBar menuOfUserAppBar(
      BuildContext context, String text, AsyncCallback bottomSheet) {
    return AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).focusColor),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(text,
            style: getMediumStyle(
                color: Theme.of(context).focusColor, fontSize: 20)),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              menuHorizontalIcon,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).focusColor, BlendMode.srcIn),
              height: 22.5,
            ),
            onPressed: () => bottomSheet,
          ),
          const SizedBox(width: 5)
        ]);
  }
}
