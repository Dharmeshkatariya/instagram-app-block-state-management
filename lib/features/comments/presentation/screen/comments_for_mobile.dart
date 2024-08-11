import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/style_resource/custom_textstyle.dart';
import '../../../../core/utils/strings_manager.dart';
import '../../../../models/post/post.dart';
import '../widgets/comment_of_post.dart';

class CommentsPageForMobile extends StatefulWidget {
  final ValueNotifier<Post> postInfo;

  const CommentsPageForMobile({super.key, required this.postInfo});

  @override
  State<CommentsPageForMobile> createState() => _CommentsPageForMobileState();
}

class _CommentsPageForMobileState extends State<CommentsPageForMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isThatMobile ? appBar(context) : null,
      body: CommentsOfPost(
        postInfo: widget.postInfo,
        selectedCommentInfo: ValueNotifier(null),
        textController: ValueNotifier(TextEditingController()),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      iconTheme: IconThemeData(color: Theme.of(context).focusColor),
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(
        StringsManager.comments.tr,
        style: getNormalStyle(color: Theme.of(context).focusColor),
      ),
    );
  }
}
