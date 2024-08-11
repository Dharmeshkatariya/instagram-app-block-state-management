import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:instagram_dharmesh_bloc_demo/features/comments/presentation/bloc/postLikes/post_likes_cubit.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/asset/asset.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/routes/getnav.dart';
import '../../../../core/style_resource/custom_textstyle.dart';
import '../../../../core/utils/strings_manager.dart';
import '../../../../core/utils/toast_show.dart';
import '../../../../core/widget/custom_widgets/custom_gallery_display.dart';
import '../../../../core/widget/others/share_button.dart';
import '../../../../models/post/post.dart';
import '../../../../models/user_personal_info.dart';
import '../../../comments/presentation/bloc/post/post_cubit.dart';
import '../../../comments/presentation/bloc/post/post_state.dart';
import '../../../comments/presentation/screen/comments_for_mobile.dart';
import '../../../user/presentation/bloc/follow/follow_cubit.dart';
import '../../../user/presentation/bloc/user_info_cubit.dart';
import '../../../user/presentation/screen/users_who_likes_for_mobile.dart';
import '../../../user/presentation/widgets/which_profile_page.dart';
import '../widgets/reel_video_play.dart';

class VideosPage extends StatefulWidget {
  final ValueNotifier<bool> stopVideo;
  final Post? clickedVideo;
  const VideosPage({super.key, required this.stopVideo, this.clickedVideo});

  @override
  VideosPageState createState() => VideosPageState();
}

class VideosPageState extends State<VideosPage> {
  ValueNotifier<Uint8List?> videoFile = ValueNotifier(null);
  ValueNotifier<bool> rebuildUserInfo = ValueNotifier(false);
  final ValueNotifier<bool> stopVideo = ValueNotifier(false);

  @override
  void initState() {
    if (stopVideo.value) stopVideo.value = widget.stopVideo.value;

    super.initState();
  }

  @override
  void didUpdateWidget(covariant VideosPage oldWidget) {
    if (stopVideo.value) stopVideo.value = widget.stopVideo.value;

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.stopVideo.value = false;
    stopVideo.dispose();
    videoFile.dispose();
    rebuildUserInfo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: ValueListenableBuilder(
          valueListenable: rebuildUserInfo,
          builder: (context, bool rebuildValue, child) =>
              BlocBuilder<PostCubit, PostState>(
                bloc: BlocProvider.of<PostCubit>(context)
                  ..getAllPostInfo(
                      isVideosWantedOnly: true,
                      skippedVideoUid: widget.clickedVideo != null
                          ? widget.clickedVideo!.postUid
                          : ""),
                buildWhen: (previous, current) {
                  if (previous != current && current is CubitAllPostsLoaded) {
                    return true;
                  }
                  if (rebuildValue && current is CubitAllPostsLoaded) {
                    rebuildUserInfo.value = false;
                    return true;
                  }
                  return false;
                },
                builder: (context, state) {
                  if (state is CubitAllPostsLoaded) {
                    return Scaffold(
                      extendBodyBehindAppBar: true,
                      appBar: isThatMobile ? appBar() : null,
                      body: buildBody(state.allPostInfo),
                    );
                  } else if (state is CubitPostFailed) {
                    ToastShow.toastStateError(state);
                    return Center(
                        child: Text(
                      StringsManager.noVideos.tr,
                      style: TextStyle(
                          color: Theme.of(context).focusColor, fontSize: 20),
                    ));
                  } else {
                    return loadingWidget();
                  }
                },
              )),
    );
  }

  AppBar appBar() => AppBar(
        backgroundColor: AppColors.transparent,
        actions: [
          IconButton(
            onPressed: () async {
              widget.stopVideo.value = false;

              await CustomImagePickerPlus.pickVideo(context);

              widget.stopVideo.value = true;
            },
            icon:
                const Icon(Icons.camera_alt, size: 30, color: AppColors.white),
          )
        ],
      );
  Widget loadingWidget() {
    return Stack(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[500]!,
          highlightColor: AppColors.shimmerDarkGrey,
          child: Container(
            width: double.infinity,
            height: double.maxFinite,
            color: AppColors.lightDarkGray,
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[600]!,
          highlightColor: AppColors.shimmerDarkGrey,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
                end: 25.0, bottom: 20, start: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.darkGray,
                ),
                const SizedBox(height: 5),
                Container(height: 15, width: 150, color: AppColors.darkGray),
                const SizedBox(height: 5),
                Container(height: 15, width: 200, color: AppColors.darkGray),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBody(List<Post> videosInfo) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: videosInfo.length,
      itemBuilder: (context, index) {
        ValueNotifier<Post> videoInfo = ValueNotifier(videosInfo[index]);
        return Stack(children: [
          SizedBox(
              height: double.infinity,
              child: ValueListenableBuilder(
                valueListenable: stopVideo,
                builder: (context, bool stopVideoValue, child) => ReelVideoPlay(
                  videoInfo: videoInfo,
                  stopVideo: stopVideoValue,
                ),
              )),
          _VerticalButtons(videoInfo: videoInfo, videoPlaying: videoPlaying),
          _HorizontalButtons(videoInfo: videoInfo, videoPlaying: videoPlaying),
        ]);
      },
    );
  }

  void videoPlaying(bool playVideo) {
    stopVideo.value = playVideo;
  }
}

class _HorizontalButtons extends StatefulWidget {
  final ValueNotifier<Post> videoInfo;
  final ValueChanged<bool> videoPlaying;

  const _HorizontalButtons(
      {Key? key, required this.videoInfo, required this.videoPlaying})
      : super(key: key);

  @override
  State<_HorizontalButtons> createState() => _HorizontalButtonsState();
}

class _HorizontalButtonsState extends State<_HorizontalButtons> {
  @override
  Widget build(BuildContext context) {
    return horizontalWidgets();
  }

  Widget horizontalWidgets() {
    return Padding(
      padding:
          const EdgeInsetsDirectional.only(end: 25.0, bottom: 20, start: 15),
      child: ValueListenableBuilder(
        valueListenable: widget.videoInfo,
        builder: (context, Post videoInfoValue, child) {
          UserPersonalInfo? personalInfo = videoInfoValue.publisherInfo;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => goToUserProfile(personalInfo),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.white,
                          backgroundImage:
                              NetworkImage(personalInfo!.profileImageUrl),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                          onTap: () => goToUserProfile(personalInfo),
                          child: Text(
                            personalInfo.name,
                            style: const TextStyle(color: AppColors.white),
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      if (videoInfoValue.publisherId != myPersonalId)
                        followButton(personalInfo),
                    ],
                  )),
              const SizedBox(height: 10),
              Text(videoInfoValue.caption,
                  style: getNormalStyle(color: AppColors.white)),
            ],
          );
        },
      ),
    );
  }

  goToUserProfile(UserPersonalInfo personalInfo) async {
    widget.videoPlaying(false);

    await Go(context).push(
        page: WhichProfilePage(
            userId: personalInfo.userId, userName: personalInfo.userName));
    widget.videoPlaying(true);
  }

  Widget followButton(UserPersonalInfo userInfo) {
    return BlocBuilder<FollowCubit, FollowState>(
      builder: (followContext, stateOfFollow) {
        return Builder(
          builder: (userContext) {
            UserPersonalInfo myPersonalInfo =
                UserInfoCubit.getMyPersonalInfo(context);
            return GestureDetector(
                onTap: () async {
                  if (myPersonalInfo.followedPeople.contains(userInfo.userId)) {
                    await BlocProvider.of<FollowCubit>(followContext)
                        .unFollowThisUser(
                            followingUserId: userInfo.userId,
                            myPersonalId: myPersonalId);
                    if (!mounted) return;
                    BlocProvider.of<UserInfoCubit>(context).updateMyFollowings(
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
                child: followText(userInfo, myPersonalInfo));
          },
        );
      },
    );
  }

  Container followText(
      UserPersonalInfo userInfo, UserPersonalInfo myPersonalInfo) {
    return Container(
      padding:
          const EdgeInsetsDirectional.only(start: 5, end: 5, bottom: 2, top: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColors.white, width: 1)),
      child: Text(
        myPersonalInfo.followedPeople.contains(userInfo.userId)
            ? StringsManager.following.tr
            : StringsManager.follow.tr,
        style: const TextStyle(color: AppColors.white),
      ),
    );
  }
}

class _VerticalButtons extends StatefulWidget {
  final ValueNotifier<Post> videoInfo;
  final ValueChanged<bool> videoPlaying;

  const _VerticalButtons(
      {Key? key, required this.videoInfo, required this.videoPlaying})
      : super(key: key);

  @override
  State<_VerticalButtons> createState() => _VerticalButtonsState();
}

class _VerticalButtonsState extends State<_VerticalButtons> {
  @override
  Widget build(BuildContext context) {
    return verticalWidgets();
  }

  Padding verticalWidgets() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 15.0, bottom: 8),
      child: Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: ValueListenableBuilder(
            valueListenable: widget.videoInfo,
            builder: (context, Post videoInfoValue, child) => Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                loveButton(videoInfoValue),
                buildSizedBox(),
                numberOfLikes(videoInfoValue),
                commentButton(videoInfoValue),
                buildSizedBox(),
                numberOfComment(videoInfoValue),
                ShareButton(
                    postInfo: widget.videoInfo, isThatForVideoPage: true),
                sizedBox(),
                GestureDetector(
                  child: SvgPicture.asset(
                    menuHorizontalIcon,
                    colorFilter: const ColorFilter.mode(
                        AppColors.white, BlendMode.srcIn),
                    height: 25,
                  ),
                ),
                sizedBox(),
              ],
            ),
          )),
    );
  }

  Widget numberOfComment(Post videoInfoValue) {
    return InkWell(
      onTap: () async => goToCommentPage(videoInfoValue),
      child: SizedBox(
        width: 30,
        height: 40,
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            "${videoInfoValue.comments.length}",
            style: const TextStyle(color: AppColors.white),
          ),
        ),
      ),
    );
  }

  goToCommentPage(Post videoInfo) async {
    widget.videoPlaying(false);
    await Go(context)
        .push(page: CommentsPageForMobile(postInfo: ValueNotifier(videoInfo)));
    widget.videoPlaying(true);
  }

  GestureDetector commentButton(Post videoInfo) {
    return GestureDetector(
      onTap: () async => goToCommentPage(videoInfo),
      child: SvgPicture.asset(
        commentIcon,
        colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
        height: 35,
      ),
    );
  }

  Widget numberOfLikes(Post videoInfo) {
    return InkWell(
      onTap: () async {
        widget.videoPlaying(false);
        await Go(context).push(
            page: UsersWhoLikesForMobile(
          showSearchBar: true,
          usersIds: videoInfo.likes,
          isThatMyPersonalId: videoInfo.publisherId == myPersonalId,
        ));
        widget.videoPlaying(true);
      },
      child: SizedBox(
        width: 30,
        height: 40,
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            "${videoInfo.likes.length}",
            style: const TextStyle(color: AppColors.white),
          ),
        ),
      ),
    );
  }

  Widget loveButton(Post videoInfo) {
    bool isLiked = videoInfo.likes.contains(myPersonalId);
    return Builder(builder: (context) {
      PostLikesCubit likeCubit = BlocProvider.of<PostLikesCubit>(context);
      return GestureDetector(
        child: !isLiked
            ? const Icon(
                Icons.favorite_border,
                color: AppColors.white,
                size: 32,
              )
            : Icon(
                Icons.favorite,
                color: AppColors.red,
                size: 32,
              ),
        onTap: () {
          setState(() {
            if (isLiked) {
              likeCubit.removeTheLikeOnThisPost(
                  postId: videoInfo.postUid, userId: myPersonalId);
              videoInfo.likes.remove(myPersonalId);
            } else {
              likeCubit.putLikeOnThisPost(
                  postId: videoInfo.postUid, userId: myPersonalId);
              videoInfo.likes.add(myPersonalId);
            }
          });
        },
      );
    });
  }

  SizedBox buildSizedBox() {
    return const SizedBox(
      height: 5,
    );
  }

  SizedBox sizedBox() {
    return const SizedBox(
      height: 25,
    );
  }
}
