import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/asset/asset.dart';
import '../../../../../core/colors/app_colors.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/customPackages/in_view_notifier/in_view_notifier_list.dart';
import '../../../../../core/customPackages/in_view_notifier/in_view_notifier_widget.dart';
import '../../../../../core/routes/getnav.dart';
import '../../../../../core/routes/hero_dialog_route.dart';
import '../../../../../core/style_resource/custom_textstyle.dart';
import '../../../../../core/utils/date_of_now.dart';
import '../../../../../core/utils/notifications_permissions.dart';
import '../../../../../core/utils/strings_manager.dart';
import '../../../../../core/utils/toast_show.dart';
import '../../../../../core/widget/circle_avatar_image/circle_avatar_name.dart';
import '../../../../../core/widget/circle_avatar_image/circle_avatar_of_profile_image.dart';
import '../../../../../core/widget/custom_widgets/custom_app_bar.dart';
import '../../../../../core/widget/custom_widgets/custom_circulars_progress.dart';
import '../../../../../core/widget/custom_widgets/custom_gallery_display.dart';
import '../../../../../core/widget/custom_widgets/custom_network_image_display.dart';
import '../../../../../core/widget/custom_widgets/custom_post_display.dart';
import '../../../../../core/widget/others/image_of_post.dart';
import '../../../../../core/widget/others/play_this_video.dart';
import '../../../../../core/widget/popup_widgets/common/jump_arrow.dart';
import '../../../../../models/comment.dart';
import '../../../../../models/notification.dart';
import '../../../../../models/post/post.dart';
import '../../../../../models/user_personal_info.dart';
import '../../../../comments/presentation/bloc/commentsInfo/cubit/comments_info_cubit.dart';
import '../../../../comments/presentation/bloc/post/post_cubit.dart';
import '../../../../comments/presentation/bloc/post/post_state.dart';
import '../../../../comments/presentation/bloc/specific_users_posts/specific_users_posts_cubit.dart';
import '../../../../comments/presentation/screen/comments_for_mobile.dart';
import '../../../../comments/presentation/widgets/comment_box.dart';
import '../../../../notification/presentation/bloc/notification_cubit.dart';
import '../../../../story/presentation/bloc/story_cubit.dart';
import '../../../../story/presentation/screen/create_story.dart';
import '../../../../story/presentation/screen/story_for_web.dart';
import '../../../../story/presentation/screen/story_page_for_mobile.dart';
import '../../../../user/presentation/bloc/user_info_cubit.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../models/post/post.dart';

class PostOfTimeLine extends StatefulWidget {
  final ValueNotifier<Post> postInfo;
  final bool playTheVideo;
  final VoidCallback reLoadData;
  final ValueChanged<int> removeThisPost;

  final int indexOfPost;
  final ValueNotifier<List<Post>> postsInfo;

  const PostOfTimeLine({
    Key? key,
    required this.postInfo,
    required this.reLoadData,
    required this.indexOfPost,
    required this.playTheVideo,
    required this.postsInfo,
    required this.removeThisPost,
  }) : super(key: key);

  @override
  State<PostOfTimeLine> createState() => _PostOfTimeLineState();
}

class _PostOfTimeLineState extends State<PostOfTimeLine>
    with TickerProviderStateMixin {
  final ValueNotifier<TextEditingController> commentTextController =
      ValueNotifier(TextEditingController());
  @override
  dispose() {
    commentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return thePostsOfHomePage(bodyHeight: 700);
  }

  Widget thePostsOfHomePage({required double bodyHeight}) {
    return Container(
      width: double.infinity,
      color: isThatMobile ? null : AppColors.white,
      child: ValueListenableBuilder(
        valueListenable: widget.postInfo,
        builder: (context, Post postInfoValue, child) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomPostDisplay(
              postInfo: widget.postInfo,
              postsInfo: widget.postsInfo,
              indexOfPost: widget.indexOfPost,
              playTheVideo: widget.playTheVideo,
              reLoadData: widget.reLoadData,
              textController: commentTextController,
              removeThisPost: widget.removeThisPost,
              selectedCommentInfo: ValueNotifier(null),
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  if (postInfoValue.comments.isNotEmpty) ...[
                    numberOfComment(postInfoValue),
                    const SizedBox(height: 8),
                  ],
                  if (isThatMobile) ...[
                    buildCommentBox(bodyHeight),
                    buildPublishingDate(postInfoValue, context),
                  ] else ...[
                    buildPublishingDate(postInfoValue, context),
                    const Divider(),
                    buildCommentBox(bodyHeight),
                  ],
                ]),
          ],
        ),
      ),
    );
  }

  Padding buildPublishingDate(Post postInfoValue, BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 11.5, top: 5.0),
      child: Text(
        DateReformat.fullDigitsFormat(
            postInfoValue.datePublished, postInfoValue.datePublished),
        style:
            getNormalStyle(color: Theme.of(context).bottomAppBarTheme.color!),
      ),
    );
  }

  void _showAddCommentModal() {
    if (isThatMobile) {
      double media = MediaQuery.of(context).viewInsets.bottom;
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: EdgeInsets.only(bottom: media),
              child: ValueListenableBuilder(
                valueListenable: commentTextController,
                builder: (context, TextEditingController textValue, child) =>
                    CommentBox(
                  isThatCommentScreen: false,
                  postInfo: widget.postInfo,
                  textController: textValue,
                  selectedCommentInfo: ValueNotifier(null),
                  userPersonalInfo: widget.postInfo.value.publisherInfo!,
                  currentFocus: ValueNotifier(FocusScopeNode()),
                  makeSelectedCommentNullable: makeSelectedCommentNullable,
                ),
              ),
            ),
          );
        },
      );
    }
  }

  makeSelectedCommentNullable(bool isThatComment) {
    widget.postInfo.value.comments.add(" ");
    commentTextController.value.text = '';
    Navigator.maybePop(context);
  }

  Widget buildCommentBox(double bodyHeight) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 11.5),
      child: GestureDetector(
        onTap: _showAddCommentModal,
        child: ValueListenableBuilder(
          valueListenable: commentTextController,
          builder: (context, TextEditingController textValue, child) => Row(
            crossAxisAlignment: textValue.text.length < 70
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.end,
            children: [
              CircleAvatarOfProfileImage(
                userInfo: widget.postInfo.value.publisherInfo!,
                bodyHeight: bodyHeight * .5,
              ),
              const SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: commentTextController.value,
                  cursorColor: AppColors.teal,
                  decoration: InputDecoration(
                    hintText: StringsManager.addComment.tr,
                    hintStyle: TextStyle(
                        color: Theme.of(context).bottomAppBarTheme.color!,
                        fontSize: 14),
                    fillColor: AppColors.black,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  enabled: !isThatMobile,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              if (isThatMobile) ...[
                GestureDetector(
                  onTap: () {
                    commentTextController.value.text += '❤';
                    _showAddCommentModal();
                  },
                  child: const Text('❤'),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    commentTextController.value.text += '🙌';
                    _showAddCommentModal();
                  },
                  child: const Text('🙌'),
                ),
                const SizedBox(width: 8),
              ] else ...[
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8.0),
                  child: InkWell(
                    onTap: () {
                      if (commentTextController.value.text.isNotEmpty) {
                        postTheComment(widget.postInfo.value.publisherInfo!);
                      }
                    },
                    child: Text(
                      StringsManager.post.tr,
                      style: getNormalStyle(
                          color: commentTextController.value.text.isNotEmpty
                              ? AppColors.blue
                              : AppColors.lightBlue),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> postTheComment(UserPersonalInfo userInfo) async {
    final whitespaceRE = RegExp(r"\s+");
    String textWithOneSpaces =
        commentTextController.value.text.replaceAll(whitespaceRE, " ");

    CommentsInfoCubit commentsInfoCubit =
        BlocProvider.of<CommentsInfoCubit>(context);
    await commentsInfoCubit.addComment(
        commentInfo: newCommentInfo(userInfo, textWithOneSpaces));
    makeSelectedCommentNullable(true);
    if (!mounted) return;

    await PostCubit.get(context)
        .updatePostInfo(postInfo: widget.postInfo.value);
    if (!mounted) return;

    BlocProvider.of<NotificationCubit>(context).createNotification(
        newNotification: createNotification(textWithOneSpaces, userInfo));

    /// To rebuild number of comments
    setState(() {});
  }

  CustomNotification createNotification(
      String textWithOneSpaces, UserPersonalInfo myPersonalInfo) {
    Post postInfo = widget.postInfo.value;
    return CustomNotification(
      text: "commented: $textWithOneSpaces",
      postId: postInfo.postUid,
      postImageUrl:
          postInfo.isThatImage ? postInfo.postUrl : postInfo.coverOfVideoUrl,
      time: DateReformat.dateOfNow(),
      senderId: myPersonalId,
      receiverId: postInfo.publisherId,
      personalUserName: myPersonalInfo.userName,
      personalProfileImageUrl: myPersonalInfo.profileImageUrl,
      isThatLike: false,
      senderName: myPersonalInfo.userName,
    );
  }

  Comment newCommentInfo(
      UserPersonalInfo myPersonalInfo, String textWithOneSpaces) {
    return Comment(
      theComment: textWithOneSpaces,
      whoCommentId: myPersonalInfo.userId,
      datePublished: DateReformat.dateOfNow(),
      postId: widget.postInfo.value.postUid,
      likes: [],
      replies: [],
    );
  }

  Widget numberOfComment(Post postInfo) {
    int commentsLength = postInfo.comments.length;
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 11.5),
      child: GestureDetector(
        onTap: () {
          if (isThatMobile) {
            Go(context)
                .push(page: CommentsPageForMobile(postInfo: widget.postInfo));
          } else {
            Navigator.of(
              context,
            ).push(HeroDialogRoute(
              builder: (context) => ImageOfPost(
                postInfo:
                    ValueNotifier(widget.postsInfo.value[widget.indexOfPost]),
                playTheVideo: widget.playTheVideo,
                indexOfPost: widget.indexOfPost,
                postsInfo: widget.postsInfo,
                removeThisPost: widget.removeThisPost,
                reLoadData: widget.reLoadData,
                popupWebContainer: true,
                selectedCommentInfo: ValueNotifier(null),
                textController: commentTextController,
              ),
            ));
          }
        },
        child: Text(
          "${StringsManager.viewAll.tr} $commentsLength ${commentsLength > 1 ? StringsManager.comments.tr : StringsManager.comment.tr}",
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}
