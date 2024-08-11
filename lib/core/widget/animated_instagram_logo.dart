import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../asset/asset.dart';
import '../screens/web_screen_layout.dart';

class InstagramLogo extends StatelessWidget {
  final Color? color;
  final bool enableOnTapForWeb;
  const InstagramLogo({super.key, this.color, this.enableOnTapForWeb = false});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: enableOnTapForWeb
            ? () => Get.offAll(const WebScreenLayout())
            : null,
        child: SvgPicture.asset(
          instagramLogo,
          height: 32,
          colorFilter: ColorFilter.mode(
              color ?? Theme.of(context).focusColor, BlendMode.srcIn),
        ),
      );
}
