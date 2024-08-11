import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:readmore/readmore.dart';

import '../../../../../core/colors/app_colors.dart';
import '../../../../../core/utils/strings_manager.dart';

class ReadMore extends StatelessWidget {
  final String text;
  final int timeLines;
  const ReadMore(this.text, this.timeLines, {super.key});
  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
      text,
      trimLines: timeLines,
      colorClickableText: AppColors.grey,
      trimMode: TrimMode.Line,
      trimCollapsedText: StringsManager.more.tr,
      trimExpandedText: StringsManager.less.tr,
      style: TextStyle(color: Theme.of(context).focusColor),
      moreStyle: const TextStyle(fontSize: 14, color: AppColors.grey),
    );
  }
}
