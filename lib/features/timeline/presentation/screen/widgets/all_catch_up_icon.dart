import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

class AllCatchUpIcon extends StatelessWidget {
  const AllCatchUpIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double size = 60;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShaderMask(
          child: SizedBox(
            width: size * 1.2,
            height: size * 1.2,
            child: SvgPicture.asset(
              noMoreData,
              height: size,
              colorFilter:
                  const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
            ),
          ),
          shaderCallback: (Rect bounds) {
            Rect rect = const Rect.fromLTRB(0, 0, size, size);
            return const LinearGradient(
              colors: <Color>[
                AppColors.blackRed,
                AppColors.redAccent,
                AppColors.yellow,
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ).createShader(rect);
          },
        ),
        const SizedBox(height: 5),
        Text(StringsManager.allCaughtUp.tr,
            style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: 15),
        Text(StringsManager.noMorePostToday.tr,
            style: Theme.of(context).textTheme.displayLarge),
      ],
    );
  }
}
