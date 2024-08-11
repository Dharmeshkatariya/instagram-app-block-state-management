import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/comments/presentation/bloc/post/post_cubit.dart';
import '../../../features/comments/presentation/bloc/post/post_state.dart';
import '../../../features/comments/presentation/widgets/comment_of_post.dart';
import '../../constants/constants.dart';
import '../others/image_of_post.dart';
import 'custom_app_bar.dart';
import 'custom_circulars_progress.dart';
import 'custom_posts_display.dart';

class GetsPostInfoAndDisplay extends StatelessWidget {
  final String postId;
  final String appBarText;
  final bool fromHeroRoute;
  const GetsPostInfoAndDisplay({
    super.key,
    required this.postId,
    required this.appBarText,
    this.fromHeroRoute = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isThatMobile
          ? CustomAppBar.oneTitleAppBar(context, appBarText,
              logoOfInstagram: true)
          : null,
      body: BlocBuilder<PostCubit, PostState>(
        bloc: PostCubit.get(context)
          ..getPostsInfo(postsIds: [postId], isThatMyPosts: false),
        buildWhen: (previous, current) {
          if (previous != current && current is CubitPostFailed) {
            return true;
          }
          return previous != current && current is CubitPostsInfoLoaded;
        },
        builder: (context, state) {
          if (state is CubitPostsInfoLoaded) {
            if (isThatMobile) {
              if (state.postsInfo.isNotEmpty &&
                  state.postsInfo[0].comments.length < 10) {
                return CommentsOfPost(
                  postInfo: ValueNotifier(state.postsInfo[0]),
                  textController: ValueNotifier(TextEditingController()),
                  selectedCommentInfo: ValueNotifier(null),
                  showImage: true,
                );
              } else {
                return CustomPostsDisplay(
                  postsInfo: state.postsInfo,
                  showCatchUp: false,
                );
              }
            } else {
              return ImageOfPost(
                postInfo: ValueNotifier(state.postsInfo[0]),
                textController: ValueNotifier(TextEditingController()),
                selectedCommentInfo: ValueNotifier(null),
                playTheVideo: true,
                indexOfPost: 0,
                popupWebContainer: true,
                postsInfo: ValueNotifier(state.postsInfo),
              );
            }
          } else {
            return ThineCircularProgress(
              strokeWidth: 1.5,
              color: Theme.of(context).iconTheme.color,
              backgroundColor: Theme.of(context).dividerColor,
            );
          }
        },
      ),
    );
  }
}
