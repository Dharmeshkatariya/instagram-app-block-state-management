import 'package:flutter/material.dart';

import '../../../models/post/post.dart';
import '../../colors/app_colors.dart';
import '../../constants/constants.dart';
import '../../routes/hero_dialog_route.dart';
import '../others/image_of_post.dart';
import '../others/play_this_video.dart';
import '../popup_widgets/mobile/popup_post.dart';
import 'custom_network_image_display.dart';

class CustomGridViewDisplay extends StatefulWidget {
  final Post postClickedInfo;
  final List<Post> postsInfo;
  final bool isThatProfile;
  final int index;
  final bool playThisVideo;
  final bool showVideoCover;
  final ValueChanged<int>? removeThisPost;
  const CustomGridViewDisplay(
      {required this.index,
      required this.postsInfo,
      this.isThatProfile = true,
      this.playThisVideo = false,
      required this.postClickedInfo,
      this.showVideoCover = false,
      this.removeThisPost,
      super.key});

  @override
  State<CustomGridViewDisplay> createState() => _CustomGridViewDisplayState();
}

class _CustomGridViewDisplayState extends State<CustomGridViewDisplay> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: createGridTileWidget());
  }

  Widget createGridTileWidget() {
    Post postInfo = widget.postClickedInfo;
    bool isThatImage = postInfo.isThatMix || postInfo.isThatImage;
    if (isThatMobile) {
      return PopupPostCard(
        postClickedInfo: postInfo,
        postsInfo: widget.postsInfo,
        isThatProfile: widget.isThatProfile,
        postClickedWidget: isThatImage ? buildCardImage() : buildCardVideo(),
      );
    } else {
      return GestureDetector(
        onTap: onTapPostForWeb,
        onLongPressEnd: (_) => onTapPostForWeb,
        child:
            isThatImage ? buildCardImage() : buildCardVideo(playVideo: false),
      );
    }
  }

  onTapPostForWeb() => Navigator.of(context).push(
        HeroDialogRoute(
          builder: (context) => ImageOfPost(
            postInfo: ValueNotifier(widget.postClickedInfo),
            playTheVideo: widget.playThisVideo,
            indexOfPost: widget.index,
            removeThisPost: widget.removeThisPost,
            postsInfo: ValueNotifier(widget.postsInfo),
            popupWebContainer: true,
            showSliderArrow: true,
            selectedCommentInfo: ValueNotifier(null),
            textController: ValueNotifier(TextEditingController()),
          ),
        ),
      );

  Widget buildCardVideo({bool? playVideo}) {
    if (!widget.isThatProfile && playVideo == null && !widget.showVideoCover) {
      return PlayThisVideo(
        videoUrl: widget.postClickedInfo.postUrl,
        blurHash: widget.postClickedInfo.blurHash,
        play: playVideo ?? widget.playThisVideo,
        withoutSound: true,
      );
    } else {
      return Stack(
        children: [
          NetworkDisplay(
            cachingWidth: 238,
            cachingHeight: 430,
            height: 250,
            blurHash: widget.postClickedInfo.blurHash,
            url: widget.postClickedInfo.coverOfVideoUrl,
          ),
          const Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.slow_motion_video,
                    color: AppColors.white, size: 20),
              )),
        ],
      );
    }
  }

  Stack buildCardImage() {
    bool isThatMultiImages = widget.postClickedInfo.imagesUrls.length > 1;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        NetworkDisplay(
          cachingHeight: 238,
          cachingWidth: 238,
          height: isThatMobile ? 150 : 300,
          isThatImage: widget.postClickedInfo.isThatImage,
          blurHash: widget.postClickedInfo.blurHash,
          url: isThatMultiImages
              ? widget.postClickedInfo.imagesUrls[0]
              : widget.postClickedInfo.postUrl,
        ),
        if (isThatMultiImages)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Icon(
                Icons.collections_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
