import 'package:flutter/material.dart';

import '../../../../../core/colors/app_colors.dart';

class PointsScrollBar extends StatelessWidget {
  final int photoCount;
  final int activePhotoIndex;
  final bool makePointsWhite;
  const PointsScrollBar({
    super.key,
    required this.photoCount,
    this.makePointsWhite = false,
    required this.activePhotoIndex,
  });

  Widget _buildDot({required bool isActive}) {
    return Padding(
      padding: const EdgeInsets.only(left: 2.0, right: 2.0),
      child: Container(
        height: isActive ? 6 : 4.0,
        width: isActive ? 6 : 4.0,
        decoration: BoxDecoration(
          color: isActive
              ? (makePointsWhite ? AppColors.white : AppColors.blue)
              : AppColors.grey,
          borderRadius: BorderRadius.circular(3.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(photoCount, (i) => i)
          .map((i) => _buildDot(isActive: i == activePhotoIndex))
          .toList(),
    );
  }
}
