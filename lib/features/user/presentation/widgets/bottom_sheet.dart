import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/asset/asset.dart';
import '../../../../core/colors/app_colors.dart';

class CustomBottomSheet extends StatelessWidget {
  final Widget headIcon;
  final Widget bodyText;
  const CustomBottomSheet({
    super.key,
    required this.headIcon,
    required this.bodyText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).splashColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      child: _ListOfBodyWidgets(bodyText: bodyText, headIcon: headIcon),
    );
  }
}

class _ListOfBodyWidgets extends StatelessWidget {
  final Widget headIcon;
  final Widget bodyText;
  const _ListOfBodyWidgets({
    Key? key,
    required this.headIcon,
    required this.bodyText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SvgPicture.asset(
            minusIcon,
            colorFilter: ColorFilter.mode(
                Theme.of(context).highlightColor, BlendMode.srcIn),
            height: 40,
          ),
          headIcon,
          const Divider(color: AppColors.grey),
          bodyText,
        ],
      ),
    );
  }
}
