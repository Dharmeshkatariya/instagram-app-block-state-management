import 'package:flutter/material.dart';

import '../../../colors/app_colors.dart';

class VolumeIcon extends StatelessWidget {
  final bool isVolumeOn;
  const VolumeIcon({super.key, this.isVolumeOn = true});

  @override
  Widget build(BuildContext context) {
    IconData icon = isVolumeOn ? Icons.volume_up : Icons.volume_off;
    return buildContainer(icon);
  }

  Container buildContainer(IconData icon) {
    return Container(
      height: 23,
      width: 23,
      padding: const EdgeInsetsDirectional.all(2),
      decoration: BoxDecoration(
        color: AppColors.black54,
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Center(
        child: Icon(icon, color: AppColors.white, size: 15),
      ),
    );
  }
}
