import 'package:video_player/video_player.dart';

import '../../../../core/widget/aimation/fade_animation.dart';
import '../../../../core/widget/custom_widgets/custom_circulars_progress.dart';
import '../../../../export.dart';
import '../../../../models/post/post.dart';

class ReelVideoPlay extends StatefulWidget {
  final ValueNotifier<Post> videoInfo;
  final bool stopVideo;

  const ReelVideoPlay(
      {Key? key, required this.videoInfo, required this.stopVideo})
      : super(key: key);

  @override
  State<ReelVideoPlay> createState() => ReelVideoPlayState();
}

class ReelVideoPlayState extends State<ReelVideoPlay> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  final ValueNotifier<Widget> videoStatusAnimation =
      ValueNotifier(const SizedBox());

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoInfo.value.postUrl))
      ..setLooping(true)
      ..initialize().then((_) => _controller.play());
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void didUpdateWidget(covariant ReelVideoPlay oldWidget) {
    if (!oldWidget.stopVideo) {
      _initializeVideoPlayerFuture = _controller.pause();
      _controller.pause();
    } else {
      _initializeVideoPlayerFuture = _controller.play();
      _controller.play();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        video(),
        ValueListenableBuilder(
          valueListenable: videoStatusAnimation,
          builder: (context, value, child) =>
              Center(child: videoStatusAnimation.value),
        ),
      ],
    );
  }

  Widget video() {
    return Builder(builder: (context) {
      return GestureDetector(
          child: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) => VideoPlayer(_controller),
                );
              } else {
                return const ThineCircularProgress(color: AppColors.white);
              }
            },
          ),
          onTap: () {
            if (!_controller.value.isInitialized) {
              return;
            }
            if (_controller.value.volume == 0) {
              videoStatusAnimation.value =
                  FadeAnimation(child: volumeContainer(Icons.volume_up));
              _controller.setVolume(1);
            } else {
              videoStatusAnimation.value =
                  FadeAnimation(child: volumeContainer(Icons.volume_off));
              _controller.setVolume(0);
            }
          },
          onLongPressStart: (LongPressStartDetails event) {
            if (!_controller.value.isInitialized) {
              return;
            }
            _controller.pause();
          },
          onLongPressEnd: (LongPressEndDetails event) {
            if (!_controller.value.isInitialized) {
              return;
            }
            _controller.play();
          });
    });
  }

  Container volumeContainer(IconData icon) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40), color: AppColors.black87),
        padding: const EdgeInsetsDirectional.all(25),
        child: popIcon(icon));
  }

  Icon popIcon(IconData icon, {bool isThatLoveIcon = false}) {
    return Icon(
      icon,
      size: isThatLoveIcon ? 100 : 23.0,
      color: AppColors.white,
    );
  }
}
