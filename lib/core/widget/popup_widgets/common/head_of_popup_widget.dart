import 'package:flutter/material.dart';
import '../../../colors/app_colors.dart';
import '../../../style_resource/custom_textstyle.dart';

class TheHeadWidgets extends StatelessWidget {
  final String text;
  final bool makeIconsBigger;
  const TheHeadWidgets(
      {super.key, required this.text, this.makeIconsBigger = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                text,
                style: makeIconsBigger
                    ? getNormalStyle(color: AppColors.black, fontSize: 20)
                    : getBoldStyle(color: AppColors.black, fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            child: Icon(
              Icons.close_rounded,
              color: AppColors.black,
              size: makeIconsBigger ? 35 : null,
            ),
          )
        ],
      ),
    );
  }
}
