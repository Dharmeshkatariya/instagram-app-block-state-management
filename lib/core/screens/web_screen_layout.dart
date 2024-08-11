import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:instagram_dharmesh_bloc_demo/core/colors/app_colors.dart';
import 'package:instagram_dharmesh_bloc_demo/features/auth/presentation/bloc/cubit/auth_cubit.dart';
import 'package:instagram_dharmesh_bloc_demo/features/auth/presentation/screen/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/comments/presentation/bloc/post/post_cubit.dart';
import '../../features/messages/presentation/screen/messages_for_web.dart';
import '../../features/notification/presentation/bloc/notification_cubit.dart';
import '../../features/shop/presentation/screen/shop_page.dart';
import '../../features/timeline/presentation/screen/all_user_time_line/all_users_time_line.dart';
import '../../features/timeline/presentation/screen/my_own_time_line/home_page.dart';
import '../../features/user/presentation/screen/personal_profile_page.dart';
import '../../injection_container.dart';
import '../../models/notification.dart';
import '../../models/user_personal_info.dart';
import '../asset/asset.dart';
import '../constants/constants.dart';
import '../routes/hero_dialog_route.dart';
import '../style_resource/custom_textstyle.dart';
import '../widget/animated_instagram_logo.dart';
import '../widget/others/notification_card_info.dart';
import '../widget/popup_widgets/web/new_post.dart';
import '../widget/screens_w.dart';

int pageOfController = 0;

class WebScreenLayout extends StatefulWidget {
  final Widget? body;
  final UserPersonalInfo? userInfoForMessagePage;
  const WebScreenLayout({super.key, this.body, this.userInfoForMessagePage});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: pageOfController);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() => page = page);
  }

  void navigationTapped(int page) {
    if (widget.body != null) {
      setState(() => page = page);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const WebScreenLayout()));
    } else {
      pageController.jumpToPage(page);
      setState(() => pageOfController = page);
    }
  }

  void onPressedAdd(int page) {
    Navigator.of(context).push(
      HeroDialogRoute(
        builder: (context) => const PopupNewPost(),
      ),
    );
    setState(() => pageOfController = page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          appBar(context),
          Expanded(
            child: widget.body ??
                PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  onPageChanged: onPageChanged,
                  children: homeScreenItems(),
                ),
          ),
        ],
      ),
    );
  }

  Container appBar(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        border: const Border(
          bottom: BorderSide(
            color: AppColors.lowOpacityGrey,
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: SizedBox(
          width: 960,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 5),
              const InstagramLogo(),
              const Expanded(child: SizedBox(width: 1)),
              Column(
                children: [
                  Center(
                    child: IconButton(
                      icon: Icon(
                        pageOfController == 0
                            ? Icons.home_rounded
                            : Icons.home_outlined,
                        color: Theme.of(context).focusColor,
                        size: 32,
                      ),
                      onPressed: () => navigationTapped(0),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
              const SizedBox(width: 5),
              IconButton(
                icon: icons(messengerIcon, pageOfController == 1,
                    biggerIcon: true),
                onPressed: () => navigationTapped(1),
              ),
              const SizedBox(width: 5),
              IconButton(
                icon: icons(addIcon, pageOfController == 2),
                onPressed: () => onPressedAdd(2),
              ),
              const SizedBox(width: 5),
              IconButton(
                icon: icons(compass, pageOfController == 3),
                onPressed: () => navigationTapped(3),
              ),
              const SizedBox(width: 5),
              PopupMenuButton<int>(
                tooltip: "Show notifications",
                constraints:
                    const BoxConstraints.tightFor(height: 360, width: 500),
                position: PopupMenuPosition.under,
                elevation: 20,
                color: Theme.of(context).splashColor,
                offset: const Offset(90, 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(
                  pageOfController == 4
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: Theme.of(context).focusColor,
                  size: 28,
                ),
                itemBuilder: (context) {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    await NotificationCubit.get(context)
                        .getNotifications(userId: myPersonalId);
                  });
                  List<CustomNotification> notifications =
                      NotificationCubit.get(context).notifications;

                  return List<PopupMenuEntry<int>>.generate(
                    notifications.length,
                    (index) => PopupMenuItem<int>(
                      value: index,
                      child: NotificationCardInfo(
                          notificationInfo: notifications[index]),
                    ),
                  );
                },
              ),
              const SizedBox(width: 5),
              buildPopupMenuButton(context),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuButton<int> buildPopupMenuButton(BuildContext context) {
    return PopupMenuButton<int>(
      tooltip: "Show profile menu",
      elevation: 20,
      constraints: const BoxConstraints.tightFor(width: 180),
      position: PopupMenuPosition.under,
      color: Theme.of(context).splashColor,
      offset: const Offset(90, 12),
      icon: const PersonalImageIcon(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      onSelected: (int item) => onSelectedProfileMenu(item),
      itemBuilder: (context) => profileItems(),
    );
  }

  onSelectedProfileMenu(int item) {
    if (item == 0) navigationTapped(5);
    if (item == 2) {
      final SharedPreferences sharePrefs = locator<SharedPreferences>();
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        AuthCubit authCubit = AuthCubit.get(context);
        await authCubit.signOut(userId: myPersonalId);

        await sharePrefs.clear();
        Get.offAll(const LoginPage(),
            duration: const Duration(milliseconds: 0));
      });
    }
  }

  List<PopupMenuEntry<int>> profileItems() => [
        PopupMenuItem<int>(
          value: 0,
          child: Row(
            children: [
              const Icon(Icons.person, size: 15),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  "Profile",
                  style: getNormalStyle(
                      color: Theme.of(context).focusColor, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              const Icon(Icons.settings_rounded, size: 15),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  "Settings",
                  style: getNormalStyle(
                      color: Theme.of(context).focusColor, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Text(
            "Log Out",
            style: getNormalStyle(
                color: Theme.of(context).focusColor, fontSize: 15),
          ),
        ),
      ];

  List<Widget> homeScreenItems() {
    return [
      const _HomePage(),
      MessagesForWeb(selectedTextingUser: widget.userInfoForMessagePage),
      const ShopPage(),
      AllUsersTimeLinePage(),
      const _PersonalProfilePage(),
    ];
  }

  SvgPicture icons(String icon, bool value, {bool biggerIcon = false}) {
    return SvgPicture.asset(
      icon,
      height: biggerIcon ? 30 : 25,
      colorFilter:
          ColorFilter.mode(Theme.of(context).focusColor, BlendMode.srcIn),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
      create: (context) => locator<PostCubit>(),
      child: HomePage(userId: myPersonalId),
    );
  }
}

class _PersonalProfilePage extends StatelessWidget {
  const _PersonalProfilePage();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
      create: (context) => locator<PostCubit>(),
      child: PersonalProfilePage(personalId: myPersonalId),
    );
  }
}
