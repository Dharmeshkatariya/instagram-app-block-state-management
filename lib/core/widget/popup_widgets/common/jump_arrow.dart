import 'package:flutter/material.dart';

import '../../../colors/app_colors.dart';

class ArrowJump extends StatelessWidget {
  final bool isThatBack;
  final bool makeArrowBigger;
  final bool topPadding;

  const ArrowJump({
    super.key,
    this.isThatBack = true,
    this.topPadding = false,
    this.makeArrowBigger = false,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon = isThatBack
        ? Icons.arrow_back_ios_rounded
        : Icons.arrow_forward_ios_rounded;

    return Padding(
      padding: EdgeInsetsDirectional.only(
          start: isThatBack ? 10.0 : 0.0,
          end: isThatBack ? 0.0 : 10.0,
          top: topPadding ? 10 : 0),
      child: Align(
        alignment: isThatBack ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          height: makeArrowBigger ? 30 : 23,
          width: makeArrowBigger ? 30 : 23,
          padding: const EdgeInsetsDirectional.all(2),
          decoration: BoxDecoration(
            color:
                makeArrowBigger ? AppColors.white : AppColors.transparentGrey,
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Center(
            child: Icon(icon, color: AppColors.black, size: 15),
          ),
        ),
      ),
    );
  }
}
