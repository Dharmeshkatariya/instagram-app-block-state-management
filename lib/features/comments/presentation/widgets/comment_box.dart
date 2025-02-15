import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/colors/app_colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/style_resource/custom_textstyle.dart';
import '../../../../core/utils/date_of_now.dart';
import '../../../../core/utils/strings_manager.dart';
import '../../../../core/widget/circle_avatar_image/circle_avatar_of_profile_image.dart';
import '../../../../models/comment.dart';
import '../../../../models/notification.dart';
import '../../../../models/post/post.dart';
import '../../../../models/user_personal_info.dart';
import '../../../notification/presentation/bloc/notification_cubit.dart';
import '../bloc/commentsInfo/cubit/comments_info_cubit.dart';
import '../bloc/commentsInfo/cubit/repliesInfo/reply_info_cubit.dart';
import '../bloc/post/post_cubit.dart';

class CommentBox extends StatefulWidget {
  final ValueNotifier<Post> postInfo;
  final ValueNotifier<FocusNode> currentFocus;
  final bool isThatCommentScreen;
  final ValueNotifier<Comment?> selectedCommentInfo;
  final UserPersonalInfo userPersonalInfo;
  final TextEditingController textController;
  final ValueChanged<bool> makeSelectedCommentNullable;
  final bool expandCommentBox;
  const CommentBox({
    super.key,
    required this.currentFocus,
    this.expandCommentBox = false,
    required this.postInfo,
    required this.selectedCommentInfo,
    required this.textController,
    required this.userPersonalInfo,
    this.isThatCommentScreen = true,
    required this.makeSelectedCommentNullable,
  });

  @override
  State<CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isThatMobile) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              textOfEmoji('❤'),
              textOfEmoji('🙌'),
              textOfEmoji('🔥'),
              textOfEmoji('👏🏻'),
              textOfEmoji('😢'),
              textOfEmoji('😍'),
              textOfEmoji('😮'),
              textOfEmoji('😂'),
            ],
          ),
          const Divider(),
        ],
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 8, end: 8),
          child: Row(
            crossAxisAlignment: widget.expandCommentBox ||
                    widget.textController.text.length < 70
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.end,
            children: [
              CircleAvatarOfProfileImage(
                userInfo: widget.userPersonalInfo,
                bodyHeight: 330,
              ),
              const SizedBox(width: 20.0),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  cursorColor: AppColors.teal,
                  focusNode: widget.currentFocus.value,
                  style: Theme.of(context).textTheme.bodyLarge,
                  maxLines: widget.expandCommentBox ? 1 : null,
                  decoration: InputDecoration.collapsed(
                      hintText: StringsManager.addComment.tr,
                      hintStyle: TextStyle(
                          color: Theme.of(context).bottomAppBarTheme.color!)),
                  autofocus: false,
                  controller: widget.textController,
                  onChanged: (e) => setState(() {}),
                ),
              ),
              if (widget.textController.text.isEmpty &&
                  !widget.isThatCommentScreen) ...[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.textController.text = '❤';
                    });
                  },
                  child: const Text('❤'),
                ),
                const SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.textController.text = '🙌';
                    });
                  },
                  child: const Text('🙌'),
                ),
              ] else ...[
                ValueListenableBuilder(
                  valueListenable: widget.selectedCommentInfo,
                  builder: (context, Comment? selectedComment, child) =>
                      InkWell(
                    onTap: () {
                      if (widget.textController.text.isNotEmpty) {
                        postTheComment(
                            widget.userPersonalInfo, selectedComment);
                      }
                    },
                    child: Text(
                      StringsManager.post.tr,
                      style: getNormalStyle(
                          color: widget.textController.text.isNotEmpty
                              ? AppColors.blue
                              : AppColors.lightBlue),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Future<void> postTheComment(
      UserPersonalInfo myPersonalInfo, Comment? selectedComment) async {
    final whitespaceRE = RegExp(r"\s+");
    String textWithOneSpaces =
        widget.textController.text.replaceAll(whitespaceRE, " ");

    if (selectedComment == null) {
      CommentsInfoCubit commentsInfoCubit =
          BlocProvider.of<CommentsInfoCubit>(context);
      await commentsInfoCubit.addComment(
          commentInfo: newCommentInfo(myPersonalInfo, textWithOneSpaces));
      widget.makeSelectedCommentNullable(true);

      /// Just to recount the number of comments in the previous page
      if (widget.isThatCommentScreen) {
        setState(() {
          dynamic lastComment = widget.postInfo.value.comments.last;
          widget.postInfo.value.comments.add(lastComment);
        });
      }
    } else {
      Comment replyInfo = newReplyInfo(
          selectedComment, myPersonalInfo.userId, textWithOneSpaces);
      await ReplyInfoCubit.get(context)
          .replyOnThisComment(replyInfo: replyInfo);
      widget.makeSelectedCommentNullable(false);
      if (!mounted) return;
      await PostCubit.get(context)
          .updatePostInfo(postInfo: widget.postInfo.value);
    }
    if (!mounted) return;

    BlocProvider.of<NotificationCubit>(context).createNotification(
        newNotification: createNotification(textWithOneSpaces, myPersonalInfo));
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
      receiverId: widget.postInfo.value.publisherId,
      personalUserName: myPersonalInfo.userName,
      personalProfileImageUrl: myPersonalInfo.profileImageUrl,
      isThatLike: false,
      senderName: myPersonalInfo.userName,
    );
  }

  Container customDivider() => Container(
      margin: const EdgeInsetsDirectional.only(bottom: 8),
      color: Colors.grey,
      width: double.infinity,
      height: 0.2);

  Widget textOfEmoji(String emoji) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.textController.text = widget.textController.text + emoji;
          widget.textController.selection = TextSelection.fromPosition(
              TextPosition(offset: widget.textController.text.length));
        });
      },
      child: Text(
        emoji,
        style:
            getNormalStyle(fontSize: 24, color: Theme.of(context).focusColor),
      ),
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

  Comment newReplyInfo(
      Comment commentInfo, String myPersonalId, String textWithOneSpaces) {
    return Comment(
      datePublished: DateReformat.dateOfNow(),
      parentCommentId: commentInfo.parentCommentId,
      postId: commentInfo.postId,
      theComment: textWithOneSpaces,
      whoCommentId: myPersonalId,
      likes: [],
    );
  }
}
