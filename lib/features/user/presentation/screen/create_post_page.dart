import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:instagram_dharmesh_bloc_demo/injection_container.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/style_resource/custom_textstyle.dart';
import '../../../../core/utils/blur_hash.dart';
import '../../../../core/utils/date_of_now.dart';
import '../../../../core/utils/strings_manager.dart';
import '../../../../core/widget/custom_widgets/custom_circulars_progress.dart';
import '../../../../models/post/post.dart';
import '../../../../models/user_personal_info.dart';
import '../../../auth/presentation/widgets/popup_calling.dart';
import '../../../comments/domain/entities/selected_bytes.dart';
import '../../../comments/presentation/bloc/post/post_cubit.dart';
import '../bloc/user_info_cubit.dart';

class CreatePostPage extends StatefulWidget {
  final SelectedImagesDetails selectedFilesDetails;
  const CreatePostPage({required this.selectedFilesDetails, super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  bool isSwitched = false;
  final isItDone = ValueNotifier(true);

  TextEditingController captionController = TextEditingController(text: "");
  late UserPersonalInfo myPersonalInfo;
  bool isThatImage = true;
  late bool multiSelectionMode;
  late SelectedByte firstSelectedByte;
  late List<SelectedByte> selectedByte;

  late File firstImage;
  @override
  void initState() {
    myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    selectedByte = widget.selectedFilesDetails.selectedFiles;
    firstSelectedByte = widget.selectedFilesDetails.selectedFiles[0];
    multiSelectionMode = widget.selectedFilesDetails.multiSelectionMode;
    isThatImage = firstSelectedByte.isThatImage;
    firstImage = firstSelectedByte.selectedFile;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
      create: (context) => locator<PostCubit>(),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: isThatMobile ? appBar(context) : null,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(
                  start: 10.0, end: 10, top: 10),
              child: Row(
                children: [
                  SizedBox(
                    height: 70,
                    width: 70,
                    child: Stack(
                      children: [
                        if (isThatImage) Image.file(firstImage),
                        if (multiSelectionMode)
                          const Padding(
                            padding: EdgeInsets.all(2),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Icon(
                                Icons.copy_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        if (!isThatImage)
                          const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.slow_motion_video_sharp,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: captionController,
                      cursorColor: AppColors.teal,
                      style: getNormalStyle(
                          color: Theme.of(context).focusColor, fontSize: 15),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: StringsManager.writeACaption.tr,
                        hintStyle: TextStyle(
                            color: Theme.of(context).bottomAppBarTheme.color!),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            buildText(StringsManager.tagPeople.tr),
            const Divider(),
            buildText(StringsManager.addLocation.tr),
            const Divider(),
            buildText(StringsManager.alsoPostTo.tr),
            Row(
              children: [
                Expanded(child: buildText(StringsManager.facebook.tr)),
                Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    isSwitched = value;
                  },
                  activeTrackColor: AppColors.blue,
                  activeColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding buildText(String text) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
          start: 7, end: 7, bottom: 10, top: 10),
      child: Text(
        text,
        style:
            getNormalStyle(fontSize: 16.5, color: Theme.of(context).focusColor),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).focusColor),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          StringsManager.newPost.tr,
          style: getNormalStyle(color: Theme.of(context).focusColor),
        ),
        actions: actionsWidgets(context));
  }

  List<Widget> actionsWidgets(BuildContext context) {
    return [
      ValueListenableBuilder(
        valueListenable: isItDone,
        builder: (context, bool isItDoneValue, child) => !isItDoneValue
            ? CustomCircularProgress(AppColors.blue)
            : IconButton(
                onPressed: () async {
                  createPost(context);
                },
                icon: Icon(
                  Icons.check_rounded,
                  size: 30,
                  color: AppColors.blue,
                ),
              ),
      ),
    ];
  }

  Future<void> createPost(BuildContext context) async {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => setState(() => isItDone.value = false));
    Post postInfo;
    File selectedFile = firstSelectedByte.selectedFile;
    Uint8List? convertedBytes;
    if (!isThatImage) {
      convertedBytes = await createThumbnail(selectedFile);
      String blurHash = convertedBytes != null
          ? await CustomBlurHash.blurHashEncode(convertedBytes)
          : "";
      postInfo = addPostInfo(blurHash);
    } else {
      Uint8List byte = await selectedFile.readAsBytes();
      String blurHash = await CustomBlurHash.blurHashEncode(byte);
      postInfo = addPostInfo(blurHash);
    }
    if (!mounted) return;

    PostCubit postCubit = BlocProvider.of<PostCubit>(context, listen: false);
    await postCubit.createPost(postInfo, selectedByte,
        coverOfVideo: convertedBytes);

    if (postCubit.newPostInfo != null) {
      if (!mounted) return;

      await UserInfoCubit.get(context).updateUserPostsInfo(
          userId: myPersonalId, postInfo: postCubit.newPostInfo!);
      await postCubit.getPostsInfo(
          postsIds: myPersonalInfo.posts, isThatMyPosts: true);
      WidgetsBinding.instance
          .addPostFrameCallback((_) => setState(() => isItDone.value = true));
    }
    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => PopupCalling(myPersonalId),
        ),
        (route) => false);
  }

  Future<Uint8List?> createThumbnail(File selectedFile) async {
    final Uint8List? convertImage = await VideoThumbnail.thumbnailData(
      video: selectedFile.path,
      imageFormat: ImageFormat.PNG,
    );

    return convertImage;
  }

  Post addPostInfo(String blurHash) {
    return Post(
      aspectRatio: widget.selectedFilesDetails.aspectRatio,
      publisherId: myPersonalId,
      datePublished: DateReformat.dateOfNow(),
      caption: captionController.text,
      blurHash: blurHash,
      imagesUrls: [],
      comments: [],
      likes: [],
    );
  }
}
