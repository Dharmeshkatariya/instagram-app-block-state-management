import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:instagram_dharmesh_bloc_demo/core/constants/constants.dart';

import '../../../../core/asset/asset.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/routes/getnav.dart';
import '../../../../core/style_resource/custom_textstyle.dart';
import '../../../../core/utils/strings_manager.dart';
import '../../../../core/utils/toast_show.dart';
import '../../../../core/widget/custom_widgets/custom_circulars_progress.dart';
import '../../../../core/widget/custom_widgets/custom_gallery_display.dart';
import '../../../../models/user_personal_info.dart';
import '../bloc/searchAboutUser/search_about_user_bloc.dart';
import '../bloc/user_info_cubit.dart';
import 'package:image_picker_plus/image_picker_plus.dart' as ipp;

import '../bloc/user_info_state.dart';

class EditProfilePage extends StatefulWidget {
  final UserPersonalInfo userInfo;

  const EditProfilePage(this.userInfo, {super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  ValueNotifier<bool> isImageUpload = ValueNotifier(true);
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController userNameController = TextEditingController(text: "");
  final TextEditingController pronounsController =
      TextEditingController(text: "");
  final TextEditingController websiteController =
      TextEditingController(text: "");
  TextEditingController bioController = TextEditingController(text: "");
  late UserPersonalInfo userInfo;

  bool reBuild = false;
  bool isImageChanged = false;
  bool userNameChanging = false;
  bool validateEdits = true;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    userInfo = widget.userInfo;
    nameController = TextEditingController(text: userInfo.name);
    userNameController = TextEditingController(text: userInfo.userName);
    bioController = TextEditingController(text: userInfo.bio);

    super.initState();
  }

  @override
  Widget build(BuildContext context1) {
    return BlocBuilder<UserInfoCubit, UserInfoState>(
      buildWhen: (previous, current) {
        if (previous != current && (current is CubitMyPersonalInfoLoaded)) {
          return true;
        }

        if (previous != current && reBuild) {
          reBuild = false;
          return true;
        }
        return false;
      },
      builder: (context, getUserState) {
        UserInfoCubit updateUserCubit = UserInfoCubit.get(context);

        if (getUserState is CubitGetUserInfoFailed) {
          ToastShow.toastStateError(getUserState);
        }
        if (getUserState is CubitMyPersonalInfoLoaded) {
          Future.delayed(Duration.zero, () {
            if (mounted) {
              setState(() {
                userInfo = getUserState.userPersonalInfo;
              });
            }
          });
        }

        return buildScaffold(context, getUserState, updateUserCubit);
      },
    );
  }

  Scaffold buildScaffold(BuildContext context, UserInfoState getUserState,
      UserInfoCubit updateUserCubit) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: isThatMobile
          ? buildAppBar(context, getUserState, updateUserCubit)
          : null,
      body: Column(
        children: [
          circleAvatarAndTextFields(context, updateUserCubit),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context, UserInfoState getUserState,
      UserInfoCubit updateUserCubit) {
    return AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).focusColor),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              cancelIcon,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).focusColor, BlendMode.srcIn),
              height: 27,
            )),
        title: Text(
          StringsManager.editProfile.tr,
          style:
              getMediumStyle(color: Theme.of(context).focusColor, fontSize: 20),
        ),
        actions: actionsWidgets(getUserState, updateUserCubit));
  }

  List<Widget> actionsWidgets(
      dynamic getUserState, UserInfoCubit updateUserCubit) {
    return [
      if (validateEdits) ...[
        getUserState is! CubitMyPersonalInfoLoaded
            ? Transform.scale(
                scaleY: 1,
                scaleX: 1.2,
                child: CustomCircularProgress(AppColors.blue))
            : ValueListenableBuilder(
                valueListenable: isImageUpload,
                builder: (context, bool isImageUploadValue, child) =>
                    IconButton(
                  onPressed: () async {
                    bool isNameChanged = nameController.text == userInfo.name;
                    bool isUserNameChanged =
                        userNameController.text == userInfo.userName;
                    bool isBioChanged = bioController.text == userInfo.bio;

                    if (isBioChanged &&
                        isUserNameChanged &&
                        isNameChanged &&
                        !isImageChanged) {
                      Go(context).back();
                    }

                    if (isImageUploadValue) {
                      reBuild = true;
                      List<dynamic> charactersOfName = [];
                      String name = nameController.text.toLowerCase();
                      for (int i = 0; i < name.length; i++) {
                        charactersOfName =
                            charactersOfName + [name.substring(0, i + 1)];
                      }
                      UserPersonalInfo updatedUserInfo = UserPersonalInfo(
                        followerPeople: userInfo.followerPeople,
                        followedPeople: userInfo.followedPeople,
                        posts: userInfo.posts,
                        userName: userNameController.text,
                        name: nameController.text,
                        bio: bioController.text,
                        profileImageUrl: userInfo.profileImageUrl,
                        email: userInfo.email,
                        charactersOfName: charactersOfName,
                        stories: userInfo.stories,
                        userId: userInfo.userId,
                        deviceToken: userInfo.deviceToken,
                        lastThreePostUrls: userInfo.lastThreePostUrls,
                        chatsOfGroups: userInfo.chatsOfGroups,
                      );
                      await updateUserCubit
                          .updateUserInfo(updatedUserInfo)
                          .whenComplete(() {
                        Future.delayed(Duration.zero, () {
                          reBuild = false;

                          Get.back();
                        });
                      });
                    }
                  },
                  icon: checkIcon(false),
                ),
              )
      ] else ...[
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 8.5),
          child: checkIcon(true),
        )
      ],
    ];
  }

  Icon checkIcon(bool light) {
    return Icon(Icons.check_rounded,
        size: 30, color: light ? AppColors.lightBlue : AppColors.blue);
  }

  Expanded circleAvatarAndTextFields(
      BuildContext context, UserInfoCubit updateUserCubit) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(10),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: textFieldsColumn(updateUserCubit),
        ),
      ),
    );
  }

  Widget textFieldsColumn(UserInfoCubit updateUserCubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        imageCircleAvatar(context),
        const SizedBox(height: 15),
        Center(
          child: InkWell(
            onTap: () async {
              onTapChangeImage(updateUserCubit);
            },
            child: Text(
              StringsManager.changeProfilePhoto.tr,
              style: getNormalStyle(fontSize: 18, color: AppColors.blue),
            ),
          ),
        ),
        textFormField(nameController, StringsManager.name.tr),
        const SizedBox(height: 10),
        userNameTextField(context),
        const SizedBox(height: 10),
        textFormField(pronounsController, StringsManager.pronouns.tr),
        const SizedBox(height: 10),
        textFormField(websiteController, StringsManager.website.tr),
        const SizedBox(height: 10),
        textFormField(bioController, StringsManager.bio.tr),
        const SizedBox(height: 15),
        const Divider(),
        const SizedBox(height: 8),
        GestureDetector(
          child: Text(
            StringsManager.personalInformationSettings.tr,
            style: getNormalStyle(fontSize: 18, color: AppColors.blue),
          ),
        ),
        const SizedBox(height: 8),
        const Divider(),
      ],
    );
  }

  onTapChangeImage(UserInfoCubit updateUserCubit) async {
    ipp.SelectedImagesDetails? details = await pushToCustomGallery(context);
    if (details == null) return;
    isImageUpload.value = false;
    Uint8List pickImage =
        await (details.selectedFiles[0].selectedFile).readAsBytes();

    await updateUserCubit.uploadProfileImage(
        photo: pickImage,
        userId: userInfo.userId,
        previousImageUrl: userInfo.profileImageUrl);
    isImageUpload.value = true;
    isImageChanged = true;
  }

  static Future<ipp.SelectedImagesDetails?> pushToCustomGallery(
      BuildContext context) async {
    ipp.ImagePickerPlus picker = ipp.ImagePickerPlus(context);
    ipp.SelectedImagesDetails? details = await picker.pickImage(
      source: ipp.ImageSource.both,
      galleryDisplaySettings: ipp.GalleryDisplaySettings(
        showImagePreview: true,
        cropImage: true,
        tabsTexts: CustomImagePickerPlus.tapsNames(),
        appTheme: CustomImagePickerPlus.appTheme(context),
      ),
    );
    return details;
  }

  // static Future<SelectedImagesDetails?> pushToCustomGallery(
  //     BuildContext context) async {
  //   ipp.   ImagePickerPlus picker = ipp.ImagePickerPlus(context);
  //   ipp.  SelectedImagesDetails? details = await picker.pickImage(
  //     source:    ipp.ImageSource.both,
  //     galleryDisplaySettings:   ipp. GalleryDisplaySettings(
  //       showImagePreview: true,
  //       cropImage: true,
  //       tabsTexts: CustomImagePickerPlus.tapsNames(),
  //       appTheme: CustomImagePickerPlus.appTheme(context),
  //     ),
  //   );
  //   return details;
  // }

  Widget userNameTextField(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isImageUpload,
      builder: (context, bool isImageUploadValue, child) =>
          BlocBuilder<SearchAboutUserBloc, SearchAboutUserState>(
        bloc: BlocProvider.of<SearchAboutUserBloc>(context)
          ..add(FindSpecificUser(userNameController.text,
              searchForSingleLetter: true)),
        buildWhen: (previous, current) =>
            previous != current &&
            (current is SearchAboutUserBlocLoaded) &&
            isImageUploadValue,
        builder: (context, state) {
          List<UserPersonalInfo> usersWithSameUserName = [];
          if (state is SearchAboutUserBlocLoaded) {
            usersWithSameUserName = state.users;
          }
          bool isIExist = usersWithSameUserName.contains(userInfo);
          WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
                validateEdits = isIExist || usersWithSameUserName.isEmpty;
                userNameChanging = userNameController.text != userInfo.userName;
              }));
          return userNameTextFormField(
            userNameController,
            StringsManager.username.tr,
            uniqueUserName: validateEdits,
          );
        },
      ),
    );
  }

  TextFormField userNameTextFormField(
      TextEditingController controller, String text,
      {required bool uniqueUserName}) {
    return TextFormField(
      cursorColor: AppColors.teal,
      controller: controller,
      style: getNormalStyle(color: Theme.of(context).focusColor, fontSize: 15),
      decoration: InputDecoration(
        labelText: text,
        suffixIcon: !userNameChanging
            ? null
            : (uniqueUserName && validateEdits ? rightIcon() : wrongIcon()),
        labelStyle: getNormalStyle(
            color: !uniqueUserName ? AppColors.red : AppColors.grey),
        errorText: uniqueUserName && validateEdits
            ? null
            : StringsManager.thisUserNameExist.tr,
        errorStyle: getNormalStyle(color: AppColors.red),
      ),
      onChanged: (value) {
        if (value.isEmpty) setState(() => validateEdits = false);
      },
    );
  }

  Icon rightIcon() {
    return const Icon(Icons.check_circle, color: AppColors.green, size: 27);
  }

  Transform wrongIcon() {
    return Transform.rotate(
      angle: pi / 3.6,
      child: Icon(
        Icons.add_circle_rounded,
        color: AppColors.red,
        size: 27,
      ),
    );
  }

  Center imageCircleAvatar(BuildContext context) {
    return Center(
        child: Stack(
      alignment: Alignment.bottomRight,
      children: [
        userCircleAvatarImage(),
      ],
    ));
  }

  Widget userCircleAvatarImage() {
    bool hasUserPhoto = userInfo.profileImageUrl.isNotEmpty;

    return GestureDetector(
      child: ValueListenableBuilder(
        valueListenable: isImageUpload,
        builder: (context, bool isImageUploadValue, child) => CircleAvatar(
          backgroundImage: isImageUploadValue && hasUserPhoto
              ? NetworkImage(userInfo.profileImageUrl)
              : null,
          radius: 50,
          backgroundColor: Theme.of(context).focusColor,
          child: ClipOval(
            child: !isImageUploadValue
                ? const ThineCircularProgress(color: AppColors.white)
                : (!hasUserPhoto
                    ? Icon(Icons.person, color: Theme.of(context).primaryColor)
                    : null),
          ),
        ),
      ),
    );
  }

  TextFormField textFormField(TextEditingController controller, String text) {
    return TextFormField(
      cursorColor: AppColors.teal,
      controller: controller,
      style: getNormalStyle(color: Theme.of(context).focusColor, fontSize: 15),
      decoration: InputDecoration(
        labelText: text,
        labelStyle: getNormalStyle(color: AppColors.grey),
        errorStyle: getNormalStyle(color: AppColors.red),
      ),
    );
  }
}
