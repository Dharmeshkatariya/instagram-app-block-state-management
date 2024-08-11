import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:instagram_dharmesh_bloc_demo/export.dart';

import '../../../../core/style_resource/custom_textstyle.dart';
import '../../../../core/utils/strings_manager.dart';

class OrText extends StatelessWidget {
  const OrText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
            child: Divider(
          indent: 30,
          endIndent: 20,
          thickness: 0.2,
          color: AppColors.grey,
        )),
        Text(
          StringsManager.or.tr,
          style: getBoldStyle(color: Theme.of(context).disabledColor),
        ),
        const Expanded(
            child: Divider(
          indent: 20,
          endIndent: 30,
          thickness: 0.2,
          color: AppColors.grey,
        )),
      ],
    );
  }
}
