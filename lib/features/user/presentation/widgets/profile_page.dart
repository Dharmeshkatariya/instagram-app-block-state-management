import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:instagram_dharmesh_bloc_demo/features/user/presentation/widgets/profile_grid_view.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/asset/asset.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/routes/getnav.dart';
import '../../../../core/routes/hero_dialog_route.dart';
import '../../../../core/style_resource/custom_textstyle.dart';
import '../../../../core/themes/theme_detector.dart';
import '../../../../core/utils/strings_manager.dart';
import '../../../../core/widget/circle_avatar_image/circle_avatar_of_profile_image.dart';
import '../../../../core/widget/popup_widgets/web/follow_card.dart';
import '../../../../models/post/post.dart';
import '../../../../models/user_personal_info.dart';
import '../../../comments/presentation/bloc/post/post_cubit.dart';
import '../../../comments/presentation/bloc/post/post_state.dart';
import '../../../timeline/presentation/screen/widgets/read_more_text.dart';
import '../screen/followers_info_page.dart';
import 'custom_videos_grid_view.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  final bool isThatMyPersonalId;
  final ValueNotifier<UserPersonalInfo> userInfo;
  final List<Widget> widgetsAboveTapBars;

  const ProfilePage(
      {required this.widgetsAboveTapBars,
      required this.isThatMyPersonalId,
      required this.userInfo,
      required this.userId,
      super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ValueNotifier<bool> reBuild = ValueNotifier(false);
  ValueNotifier<int> tabBarIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return isThatMobile ? buildForMobile() : buildForWeb();
  }

  Widget buildForWeb() {
    return SingleChildScrollView(
      child: Center(
        child: SizedBox(
          width: isThatMobile ? null : 920,
          child: DefaultTabController(
            length: 3,
            child: ValueListenableBuilder(
              valueListenable: widget.userInfo,
              builder: (context, UserPersonalInfo userInfoValue, child) =>
                  widgetsAboveTapBarsForWeb(userInfoValue),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildForMobile() {
    return Center(
      child: SizedBox(
        width: isThatMobile ? null : 920,
        child: DefaultTabController(
          length: 3,
          child: ValueListenableBuilder(
            valueListenable: widget.userInfo,
            builder: (context, UserPersonalInfo userInfoValue, child) =>
                NestedScrollView(
              headerSliverBuilder: (_, __) {
                return [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      widgetsAboveTapBarsForMobile(userInfoValue),
                    ),
                  ),
                ];
              },
              body: tapBar(),
            ),
          ),
        ),
      ),
    );
  }

  Widget tapBar() {
    return BlocBuilder<PostCubit, PostState>(
      bloc: PostCubit.get(context)
        ..getPostsInfo(
            postsIds: widget.userInfo.value.posts,
            isThatMyPosts: widget.isThatMyPersonalId),
      buildWhen: (previous, current) {
        if (reBuild.value) {
          reBuild.value = false;
          return true;
        }
        if (previous != current && current is CubitPostFailed) {
          return true;
        }
        return previous != current &&
            ((current is CubitMyPersonalPostsLoaded &&
                    widget.isThatMyPersonalId) ||
                (current is CubitPostsInfoLoaded &&
                    !widget.isThatMyPersonalId));
      },
      builder: (BuildContext context, PostState state) {
        if (state is CubitMyPersonalPostsLoaded && widget.isThatMyPersonalId) {
          return columnOfWidgets(state.postsInfo);
        } else if (state is CubitPostsInfoLoaded &&
            !widget.isThatMyPersonalId) {
          return columnOfWidgets(state.postsInfo);
        } else {
          return isThatMobile
              ? const SingleChildScrollView(child: _LoadingGridView())
              : const _LoadingGridView();
        }
      },
    );
  }

  Column columnOfWidgets(List<Post> postsInfo) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TabBarIcons(tapBarIndex: tabBarIndex),
        _TabBarsViews(
            postsInfo: postsInfo,
            userId: widget.userId,
            tapBarIndex: tabBarIndex),
      ],
    );
  }

  Widget widgetsAboveTapBarsForWeb(UserPersonalInfo userInfo) {
    double widthOfScreen = MediaQuery.of(context).size.width;
    bool isWidthAboveMinimum = widthOfScreen > 800;
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: isWidthAboveMinimum ? 60 : 40, vertical: 30),
              child: CircleAvatarOfProfileImage(
                bodyHeight: isWidthAboveMinimum ? 1500 : 900,
                userInfo: userInfo,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        userInfo.userName,
                        style: TextStyle(
                            color: Theme.of(context).focusColor,
                            fontSize: isWidthAboveMinimum ? 25 : 15,
                            fontWeight: FontWeight.w100),
                      ),
                      ...widget.widgetsAboveTapBars,
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        personalNumbersInfo(userInfo.posts, userInfo,
                            isThatFollowers: null),
                        const SizedBox(width: 20),
                        personalNumbersInfo(userInfo.followerPeople, userInfo,
                            isThatFollowers: true),
                        const SizedBox(width: 20),
                        personalNumbersInfo(userInfo.followedPeople, userInfo,
                            isThatFollowers: false),
                      ],
                    ),
                  ),
                  Text(userInfo.name,
                      style: Theme.of(context).textTheme.displayMedium),
                  const SizedBox(height: 5),
                  Text(userInfo.bio,
                      style: getNormalStyle(
                          color: Theme.of(context).focusColor, fontSize: 15)),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
        tapBar(),
      ],
    );
  }

  List<Widget> widgetsAboveTapBarsForMobile(UserPersonalInfo userInfo) {
    final mediaQuery = MediaQuery.of(context);
    final bodyHeight = mediaQuery.size.height -
        AppBar().preferredSize.height -
        mediaQuery.padding.top;
    return [
      Column(
        children: [
          personalPhotoAndNumberInfo(userInfo, bodyHeight),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 15.0, top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userInfo.name,
                    style: Theme.of(context).textTheme.displayMedium),
                ReadMore(userInfo.bio, 4),
                const SizedBox(height: 10),
                Row(
                  children: widget.widgetsAboveTapBars,
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  Row personalPhotoAndNumberInfo(UserPersonalInfo userInfo, double bodyHeight) {
    String hash = "${userInfo.userId.hashCode}personal";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Hero(
          tag: hash,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 15.0, top: 10),
            child: CircleAvatarOfProfileImage(
              bodyHeight: bodyHeight * 1.45,
              userInfo: userInfo,
              hashTag: hash,
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Container(height: bodyHeight * .055),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  personalNumbersInfo(userInfo.posts, userInfo,
                      isThatFollowers: null),
                  personalNumbersInfo(userInfo.followerPeople, userInfo,
                      isThatFollowers: true),
                  personalNumbersInfo(userInfo.followedPeople, userInfo,
                      isThatFollowers: false),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  updateUserInfo() {
    reBuild.value = true;
  }

  Widget personalNumbersInfo(List<dynamic> usersIds, UserPersonalInfo userInfo,
      {bool? isThatFollowers}) {
    String text = isThatFollowers == null
        ? StringsManager.posts.tr
        : isThatFollowers
            ? StringsManager.followers.tr
            : StringsManager.following.tr;
    return Builder(builder: (builderContext) {
      List<Widget> userInfoWidgets = [
        Text(
          "${usersIds.length}",
          style: getBoldStyle(
              color: Theme.of(context).focusColor,
              fontSize: isThatMobile ? 20 : 15),
        ),
        if (!isThatMobile) const SizedBox(width: 5),
        Text(text,
            style: getNormalStyle(
                color: Theme.of(context).focusColor, fontSize: 15)),
      ];
      return ValueListenableBuilder(
        valueListenable: widget.userInfo,
        builder: (context, UserPersonalInfo userInfoValue, child) =>
            GestureDetector(
          onTap: () async {
            if (isThatFollowers != null) {
              if (isThatMobile) {
                await Go(context).push(
                    page: FollowersInfoPage(
                  userInfo: widget.userInfo,
                  initialIndex: usersIds == userInfo.followerPeople ? 0 : 1,
                  updateFollowersCallback: updateUserInfo,
                ));
              } else {
                await Navigator.of(context).push(
                  HeroDialogRoute(
                    builder: (context) => PopupFollowCard(
                      usersIds: usersIds,
                      isThatFollower: isThatFollowers,
                      isThatMyPersonalId: userInfo.userId == myPersonalId,
                    ),
                  ),
                );
              }
            }
          },
          child: isThatMobile
              ? Column(children: userInfoWidgets)
              : Row(children: userInfoWidgets),
        ),
      );
    });
  }
}

class _LoadingGridView extends StatelessWidget {
  const _LoadingGridView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool isWidthAboveMinimum = MediaQuery.of(context).size.width > 800;

    return Column(
      children: [
        _TabBarIcons(tapBarIndex: ValueNotifier(0)),
        Shimmer.fromColors(
          baseColor: Theme.of(context).textTheme.headlineSmall!.color!,
          highlightColor: Theme.of(context).textTheme.titleLarge!.color!,
          child: SizedBox(
            width: isThatMobile ? null : 920,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              primary: false,
              padding: const EdgeInsetsDirectional.only(bottom: 1.5, top: 1.5),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: isWidthAboveMinimum ? 30 : 1.5,
                mainAxisSpacing: isWidthAboveMinimum ? 30 : 1.5,
              ),
              itemBuilder: (_, __) {
                return Container(
                    color: AppColors.lightDarkGray, width: double.infinity);
              },
              itemCount: 15,
            ),
          ),
        ),
      ],
    );
  }
}

class _TabBarsViews extends StatelessWidget {
  const _TabBarsViews({
    Key? key,
    required this.postsInfo,
    required this.userId,
    required this.tapBarIndex,
  }) : super(key: key);
  final List<Post> postsInfo;
  final ValueNotifier<int> tapBarIndex;

  final String userId;

  @override
  Widget build(BuildContext context) {
    if (isThatMobile) {
      return Expanded(
        child: TabBarView(children: _tabBarsWidgets(postsInfo, userId)),
      );
    } else {
      return SizedBox(
        width: 920,
        child: ValueListenableBuilder(
          valueListenable: tapBarIndex,
          builder: (context, int index, child) =>
              _tabBarsWidgets(postsInfo, userId)[index],
        ),
      );
    }
  }
}

List<Widget> _tabBarsWidgets(List<Post> postsInfo, String userId) {
  List<Post> videosPostsInfo = postsInfo
      .where((element) => !(element.isThatMix || element.isThatImage))
      .toList();

  List<Post> imagesPostsInfo = postsInfo
      .where((element) => (element.isThatMix || element.isThatImage))
      .toList();
  return [
    ProfileGridView(postsInfo: imagesPostsInfo, userId: userId),
    CustomVideosGridView(postsInfo: videosPostsInfo, userId: userId),
    ProfileGridView(postsInfo: imagesPostsInfo, userId: userId),
  ];
}

class _TabBarIcons extends StatelessWidget {
  const _TabBarIcons({Key? key, required this.tapBarIndex}) : super(key: key);
  final ValueNotifier<int> tapBarIndex;
  @override
  Widget build(BuildContext context) {
    bool isWidthAboveMinimum = MediaQuery.of(context).size.width > 800;

    return TabBar(
      onTap: (value) {
        tapBarIndex.value = value;
      },
      unselectedLabelColor: AppColors.grey,
      labelColor: isWidthAboveMinimum
          ? AppColors.black
          : (isThatMobile ? Theme.of(context).focusColor : AppColors.blue),
      labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w100),
      indicatorSize: isThatMobile ? null : TabBarIndicatorSize.label,
      isScrollable: isWidthAboveMinimum ? true : false,
      labelPadding: isWidthAboveMinimum
          ? const EdgeInsetsDirectional.only(
              start: 50, end: 50, top: 5, bottom: 3)
          : null,
      indicatorWeight: isWidthAboveMinimum ? 2 : (isThatMobile ? 2 : 0),
      indicator: isThatMobile
          ? null
          : BoxDecoration(
              border: Border(
                top: BorderSide(
                    color: isWidthAboveMinimum
                        ? Theme.of(context).focusColor
                        : AppColors.transparent,
                    width: 1),
              ),
            ),
      tabs: [
        Tab(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.grid_on_rounded,
                size: isWidthAboveMinimum ? 14 : null,
              ),
              if (isWidthAboveMinimum) ...[
                const SizedBox(width: 8),
                Text(
                  StringsManager.postsCap.tr,
                ),
              ],
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder(
                valueListenable: tapBarIndex,
                builder: (context, int tapBarIndexValue, child) =>
                    SvgPicture.asset(
                  videoIcon,
                  colorFilter: ColorFilter.mode(
                      tapBarIndexValue == 1
                          ? ThemeOfApp.isThemeDark()
                              ? AppColors.white
                              : AppColors.black
                          : AppColors.grey,
                      BlendMode.srcIn),
                  height: isWidthAboveMinimum ? 14 : 22.5,
                ),
              ),
              if (isWidthAboveMinimum) ...[
                const SizedBox(width: 8),
                Text(StringsManager.reels.tr),
              ],
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.play_arrow_rounded,
                size: isWidthAboveMinimum ? 22 : 38,
              ),
              if (isWidthAboveMinimum) ...[
                const SizedBox(width: 8),
                Text(StringsManager.videos.tr),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
