import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../features/timeline/presentation/screen/widgets/send_to_users.dart';
import '../../../models/post/post.dart';
import '../../../models/user_personal_info.dart';
import '../../asset/asset.dart';
import '../../colors/app_colors.dart';
import '../../constants/constants.dart';
import '../../customPackages/sliding_sheet/src/sheet.dart';
import '../../customPackages/sliding_sheet/src/specs.dart';
import '../../routes/getnav.dart';
import '../../routes/hero_dialog_route.dart';
import '../../style_resource/custom_textstyle.dart';
import '../../utils/strings_manager.dart';
import '../popup_widgets/web/share_post.dart';

class ShareButton extends StatefulWidget {
  final ValueNotifier<Post> postInfo;
  final Widget? shareWidget;
  final bool isThatForVideoPage;
  const ShareButton(
      {super.key,
      required this.postInfo,
      this.shareWidget,
      this.isThatForVideoPage = false});

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  final _bottomSheetMessageTextController = TextEditingController();
  final _bottomSheetSearchTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return shareButton();
  }

  Widget shareButton() {
    return GestureDetector(
      onTap: () async {
        if (isThatMobile) {
          if (widget.shareWidget != null) Go(context).back();

          await draggableBottomSheet();
        } else {
          Navigator.of(context).push(heroDialogRoute());
        }
      },
      child: widget.shareWidget ??
          Padding(
            padding: EdgeInsetsDirectional.only(
                start: widget.isThatForVideoPage ? 0 : 15.0),
            child: iconsOfImagePost(send1Icon),
          ),
    );
  }

  HeroDialogRoute<dynamic> heroDialogRoute() {
    return HeroDialogRoute(
      builder: (context) => PopupSharePost(
        postInfo: widget.postInfo.value,
        publisherInfo: widget.postInfo.value.publisherInfo!,
      ),
    );
  }

  SvgPicture iconsOfImagePost(String path) {
    return SvgPicture.asset(
      path,
      colorFilter: ColorFilter.mode(
          widget.isThatForVideoPage
              ? AppColors.white
              : Theme.of(context).focusColor,
          BlendMode.srcIn),
      height: !widget.isThatForVideoPage ? 22 : 25,
    );
  }

  Future<void> draggableBottomSheet() async {
    return showSlidingBottomSheet<void>(
      context,
      builder: (BuildContext context) => SlidingSheetDialog(
        cornerRadius: 16,
        minHeight: 200,
        color: Theme.of(context).splashColor,
        snapSpec: const SnapSpec(initialSnap: 1, snappings: [.4, 1, .7]),
        builder: buildSheet,
        headerBuilder: (context, state) =>
            Material(child: upperWidgets(context)),
      ),
    );
  }

  Column upperWidgets(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        dashIcon(context),
        Row(
          children: [
            postImage(),
            const SizedBox(width: 12),
            textFieldOfMessage(),
          ],
        ),
        searchBar(context)
      ],
    );
  }

  Padding searchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
          top: 30.0, end: 20, start: 20, bottom: 10),
      child: Container(
        width: double.infinity,
        height: 35,
        decoration: BoxDecoration(
            color: Theme.of(context).chipTheme.backgroundColor,
            borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
          cursorColor: AppColors.teal,
          style: Theme.of(context).textTheme.bodyLarge,
          controller: _bottomSheetSearchTextController,
          textAlign: TextAlign.start,
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                size: 20,
                color: Theme.of(context).textTheme.displayLarge!.color!,
              ),
              contentPadding: const EdgeInsetsDirectional.all(12),
              hintText: StringsManager.search.tr,
              hintStyle: Theme.of(context).textTheme.displayLarge,
              border: InputBorder.none),
          onChanged: (_) => setState(() {}),
        ),
      ),
    );
  }

  Flexible textFieldOfMessage() {
    return Flexible(
      child: TextField(
        controller: _bottomSheetMessageTextController,
        cursorColor: AppColors.teal,
        style: getNormalStyle(color: Theme.of(context).focusColor),
        decoration: InputDecoration(
          hintText: StringsManager.writeMessage.tr,
          hintStyle: const TextStyle(color: AppColors.grey),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Padding postImage() {
    Post postInfo = widget.postInfo.value;
    String postImageUrl = postInfo.imagesUrls.length > 1
        ? postInfo.imagesUrls[0]
        : postInfo.postUrl;
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Container(
        width: 50,
        height: 45,
        decoration: BoxDecoration(
          color: AppColors.grey,
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
            image: NetworkImage(
                postInfo.isThatImage ? postImageUrl : postInfo.coverOfVideoUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Padding dashIcon(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 10),
      child: Container(
        width: 45,
        height: 4.5,
        decoration: BoxDecoration(
          color: Theme.of(context).textTheme.headlineMedium!.color,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  clearTextsController(bool clearText) {
    setState(() {
      if (clearText) {
        _bottomSheetMessageTextController.clear();
        _bottomSheetSearchTextController.clear();
      }
    });
  }

  Widget buildSheet(_, __) => Material(
        child: SendToUsers(
          publisherInfo: widget.postInfo.value.publisherInfo!,
          messageTextController: _bottomSheetMessageTextController,
          postInfo: widget.postInfo.value,
          clearTexts: clearTextsController,
          selectedUsersInfo: ValueNotifier<List<UserPersonalInfo>>([]),
        ),
      );
}
