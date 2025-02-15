import 'package:flutter/material.dart';
import 'package:image_picker_plus/image_picker_plus.dart';

import '../../../features/timeline/presentation/screen/widgets/image_slider.dart';
import '../../../features/timeline/presentation/screen/widgets/points_scroll_bar.dart';
import 'custom_memory_image_display.dart';

class CustomMultiImagesDisplay extends StatelessWidget {
  final initPosition = ValueNotifier(0);
  final List<SelectedByte> selectedImages;
  CustomMultiImagesDisplay({super.key, required this.selectedImages});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(top: 8.0),
            child: selectedImages.length > 1
                ? ImagesSlider(
                    aspectRatio: 1,
                    imagesUrls: selectedImages,
                    isImageFromNetwork: false,
                    updateImageIndex: _updateImageIndex,
                  )
                : Hero(
                    tag: selectedImages[0],
                    child: MemoryDisplay(
                        imagePath: selectedImages[0].selectedByte),
                  ),
          ),
        ),
        if (selectedImages.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder(
                  valueListenable: initPosition,
                  builder: (BuildContext context, int value, Widget? child) =>
                      PointsScrollBar(
                    photoCount: selectedImages.length,
                    activePhotoIndex: value,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _updateImageIndex(int index, _) {
    initPosition.value = index;
  }
}
