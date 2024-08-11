import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/asset/asset.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/routes/getnav.dart';
import '../../../../core/style_resource/custom_textstyle.dart';
import '../../../../core/translations/app_lang.dart';
import '../../../../core/utils/date_of_now.dart';
import '../../../../core/utils/strings_manager.dart';
import '../../../../core/utils/toast_show.dart';
import '../../../../core/widget/circle_avatar_image/circle_avatar_of_profile_image.dart';
import '../../../../core/widget/custom_widgets/custom_circulars_progress.dart';
import '../../../../core/widget/custom_widgets/custom_linears_progress.dart';
import '../../../../core/widget/custom_widgets/custom_smart_refresh.dart';
import '../../../../injection_container.dart';
import '../../../../models/message.dart';
import '../../../../models/user_personal_info.dart';
import '../../../user/domain/entities/sender_info.dart';
import '../../../user/presentation/bloc/user_info_cubit.dart';
import '../../../user/presentation/bloc/users_info_cubit.dart';
import '../../../user/presentation/bloc/users_info_reel_time/users_info_reel_time_bloc.dart';
import 'activity_for_mobile.dart';

class ActivityForWeb extends StatelessWidget {
  const ActivityForWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Widget>(
      elevation: 20,
      color: Theme.of(context).splashColor,
      offset: const Offset(90, 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: SvgPicture.asset(
        add2Icon,
        colorFilter:
            ColorFilter.mode(Theme.of(context).focusColor, BlendMode.srcIn),
        height: 700,
        width: 500,
      ),
      itemBuilder: (context) => [
        const PopupMenuItem<Widget>(child: ActivityPage()),
      ],
    );
  }
}
