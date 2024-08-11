import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../core/asset/asset.dart';
import '../../../../../core/colors/app_colors.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/customPackages/in_view_notifier/in_view_notifier_list.dart';
import '../../../../../core/customPackages/in_view_notifier/in_view_notifier_widget.dart';
import '../../../../../core/routes/getnav.dart';
import '../../../../../core/style_resource/custom_textstyle.dart';
import '../../../../../core/utils/notifications_permissions.dart';
import '../../../../../core/utils/strings_manager.dart';
import '../../../../../core/utils/toast_show.dart';
import '../../../../../core/widget/circle_avatar_image/circle_avatar_name.dart';
import '../../../../../core/widget/circle_avatar_image/circle_avatar_of_profile_image.dart';
import '../../../../../core/widget/custom_widgets/custom_app_bar.dart';
import '../../../../../core/widget/custom_widgets/custom_circulars_progress.dart';
import '../../../../../core/widget/custom_widgets/custom_gallery_display.dart';
import '../../../../../core/widget/custom_widgets/custom_network_image_display.dart';
import '../../../../../core/widget/others/play_this_video.dart';
import '../../../../../core/widget/popup_widgets/common/jump_arrow.dart';
import '../../../../../models/post/post.dart';
import '../../../../../models/user_personal_info.dart';
import '../../../../comments/presentation/bloc/post/post_cubit.dart';
import '../../../../comments/presentation/bloc/post/post_state.dart';
import '../../../../comments/presentation/bloc/specific_users_posts/specific_users_posts_cubit.dart';
import '../../../../story/presentation/bloc/story_cubit.dart';
import '../../../../story/presentation/screen/create_story.dart';
import '../../../../story/presentation/screen/story_for_web.dart';
import '../../../../story/presentation/screen/story_page_for_mobile.dart';
import '../../../../user/presentation/bloc/user_info_cubit.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../models/post/post.dart';
import '../../../../user/presentation/widgets/which_profile_page.dart';
import '../widgets/image_slider.dart';
import '../widgets/points_scroll_bar.dart';

class UpdatePostInfo extends StatefulWidget {
  final Post oldPostInfo;

  const UpdatePostInfo({required this.oldPostInfo, super.key});

  @override
  State<UpdatePostInfo> createState() => _UpdatePostInfoState();
}

class _UpdatePostInfoState extends State<UpdatePostInfo> {
  TextEditingController controller = TextEditingController();
  ValueNotifier<int> initPosition = ValueNotifier(0);

  @override
  void initState() {
    controller = TextEditingController(text: widget.oldPostInfo.caption);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bodyHeight = mediaQuery.size.height -
        AppBar().preferredSize.height -
        mediaQuery.padding.top;
    return Scaffold(
        appBar: isThatMobile ? buildAppBar(context) : null,
        body: buildSizedBox(bodyHeight, context));
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Theme.of(context).focusColor),
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      leading: IconButton(
          onPressed: () {
            Navigator.maybePop(context);
          },
          icon: SvgPicture.asset(
            cancelIcon,
            colorFilter:
                ColorFilter.mode(Theme.of(context).focusColor, BlendMode.srcIn),
            height: 27,
          )),
      title: Text(
        StringsManager.editInfo.tr,
        style:
            getMediumStyle(color: Theme.of(context).focusColor, fontSize: 20),
      ),
      actions: [actionsWidgets()],
    );
  }

  Widget actionsWidgets() {
    return BlocBuilder<PostCubit, PostState>(builder: (context, state) {
      return state is CubitUpdatePostLoading
          ? Transform.scale(
              scaleY: 1,
              scaleX: 1.2,
              child: CustomCircularProgress(AppColors.blue))
          : IconButton(
              onPressed: () async {
                Post updatedPostInfo = widget.oldPostInfo;
                updatedPostInfo.caption = controller.text;
                await PostCubit.get(context)
                    .updatePostInfo(postInfo: updatedPostInfo)
                    .then((value) {
                  Navigator.maybePop(context);
                });
              },
              icon: Icon(
                Icons.check_rounded,
                size: 30,
                color: AppColors.blue,
              ));
    });
  }

  SizedBox buildSizedBox(double bodyHeight, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatarOfProfileImage(
                      bodyHeight: bodyHeight * .5,
                      userInfo: widget.oldPostInfo.publisherInfo!,
                    ),
                    const SizedBox(width: 5),
                    InkWell(
                        onTap: () => pushToProfilePage(widget.oldPostInfo),
                        child: NameOfCircleAvatar(
                            widget.oldPostInfo.publisherInfo!.name, false)),
                  ],
                ),
              ),
              ...imageOfPost(widget.oldPostInfo, bodyHeight),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 12.0, end: 12),
                child: TextFormField(
                  controller: controller,
                  cursorColor: AppColors.teal,
                  style: getNormalStyle(
                      color: Theme.of(context).focusColor, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: StringsManager.writeACaption.tr,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.blue),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.blue),
                    ),
                    hintStyle: TextStyle(
                        color: Theme.of(context).bottomAppBarTheme.color!),
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  pushToProfilePage(Post postInfo) => Go(context).push(
      page: WhichProfilePage(userId: postInfo.publisherId), withoutRoot: false);

  void _updateImageIndex(int index, _) {
    initPosition.value = index;
  }

  List<Widget> imageOfPost(Post postInfo, double bodyHeight) {
    String postUrl =
        postInfo.postUrl.isNotEmpty ? postInfo.postUrl : postInfo.imagesUrls[0];
    bool isThatImage = postInfo.isThatImage;
    return [
      GestureDetector(
        child: Padding(
          padding: const EdgeInsetsDirectional.only(top: 8.0),
          child: postInfo.imagesUrls.length > 1
              ? ImagesSlider(
                  aspectRatio: postInfo.aspectRatio,
                  blurHash: postInfo.blurHash,
                  imagesUrls: postInfo.imagesUrls,
                  updateImageIndex: _updateImageIndex,
                )
              : (isThatImage
                  ? Hero(
                      tag: postUrl,
                      child: NetworkDisplay(
                        blurHash: postInfo.blurHash,
                        isThatImage: isThatImage,
                        url: postUrl,
                      ),
                    )
                  : PlayThisVideo(
                      videoUrl: postInfo.postUrl,
                      blurHash: postInfo.blurHash,
                      play: true,
                    )),
        ),
      ),
      if (postInfo.imagesUrls.length > 1)
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder(
                valueListenable: initPosition,
                builder: (BuildContext context, int value, Widget? child) =>
                    PointsScrollBar(
                  photoCount: postInfo.imagesUrls.length,
                  activePhotoIndex: value,
                ),
              ),
            ],
          ),
        ),
    ];
  }
}
