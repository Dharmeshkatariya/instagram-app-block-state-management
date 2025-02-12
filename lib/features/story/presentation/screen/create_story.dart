import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../core/asset/asset.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/style_resource/custom_textstyle.dart';
import '../../../../core/utils/blur_hash.dart';
import '../../../../core/utils/date_of_now.dart';
import '../../../../core/utils/strings_manager.dart';
import '../../../../core/widget/custom_widgets/custom_elevated_button.dart';
import '../../../../core/widget/custom_widgets/custom_multi_posts_display.dart';
import '../../../../models/post/story.dart';
import '../../../../models/user_personal_info.dart';
import '../../../auth/presentation/widgets/popup_calling.dart';
import '../../../user/presentation/bloc/user_info_cubit.dart';
import '../bloc/story_cubit.dart';

class CreateStoryPage extends StatefulWidget {
  final SelectedImagesDetails storiesDetails;

  const CreateStoryPage({super.key, required this.storiesDetails});

  @override
  State<CreateStoryPage> createState() => _CreateStoryPageState();
}

class _CreateStoryPageState extends State<CreateStoryPage> {
  bool isItDone = true;
  late List<SelectedByte> selectedFiles;
  @override
  void initState() {
    selectedFiles = widget.storiesDetails.selectedFiles;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: widget.storiesDetails.multiSelectionMode
                  ? CustomMultiImagesDisplay(selectedImages: selectedFiles)
                  : Image.file(selectedFiles[0].selectedFile),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(25.0)),
              ),
              child: listOfAddPost(),
            ),
          ],
        ),
      ),
    );
  }

  Widget listOfAddPost() {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            minusIcon,
            colorFilter:
                ColorFilter.mode(Theme.of(context).focusColor, BlendMode.srcIn),
            height: 40,
          ),
          Text(StringsManager.create.tr,
              style: getMediumStyle(
                  color: Theme.of(context).focusColor, fontSize: 20)),
          const Divider(),
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 8.0),
            child: Builder(builder: (builderContext) {
              UserInfoCubit userCubit =
                  BlocProvider.of<UserInfoCubit>(builderContext, listen: false);
              UserPersonalInfo? personalInfo = userCubit.myPersonalInfo;

              return Container(
                margin: const EdgeInsetsDirectional.all(3.0),
                child: CustomElevatedButton(
                  onPressed: () async {
                    return await createStory(personalInfo, userCubit);
                  },
                  isItDone: isItDone,
                  nameOfButton: StringsManager.share.tr,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Future<void> createStory(
      UserPersonalInfo personalInfo, UserInfoCubit userCubit) async {
    if (isItDone) {
      setState(() => isItDone = false);
      for (final storyDetails in selectedFiles) {
        Uint8List story = storyDetails.selectedByte;
        if (!storyDetails.isThatImage) {
          story = await createThumbnail(storyDetails.selectedFile) ?? story;
        }
        String blurHash = await CustomBlurHash.blurHashEncode(story);
        Story storyInfo =
            addStoryInfo(personalInfo, blurHash, storyDetails.isThatImage);
        if (!mounted) return;
        StoryCubit storyCubit = StoryCubit.get(context);
        await storyCubit.createStory(storyInfo, story);
        if (storyCubit.storyId != '') {
          userCubit.updateMyStories(storyId: storyCubit.storyId);
        }
        final SharedPreferences sharePrefs =
            await SharedPreferences.getInstance();
        WidgetsBinding.instance
            .addPostFrameCallback((_) => setState(() => isItDone = true));
        sharePrefs.remove(myPersonalId);
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(builder: (_) => PopupCalling(myPersonalId)),
          (route) => false,
        );
      }
    }
  }

  Future<Uint8List?> createThumbnail(File selectedFile) async {
    final Uint8List? convertImage = await VideoThumbnail.thumbnailData(
      video: selectedFile.path,
      imageFormat: ImageFormat.PNG,
    );

    return convertImage;
  }

  Story addStoryInfo(
      UserPersonalInfo personalInfo, String blurHash, bool isThatImage) {
    return Story(
      publisherId: personalInfo.userId,
      datePublished: DateReformat.dateOfNow(),
      caption: "",
      comments: [],
      likes: [],
      blurHash: blurHash,
      isThatImage: isThatImage,
    );
  }
}
