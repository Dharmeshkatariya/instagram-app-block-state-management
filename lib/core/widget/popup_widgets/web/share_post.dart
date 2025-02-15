import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../features/timeline/presentation/screen/widgets/send_to_users.dart';
import '../../../../models/post/post.dart';
import '../../../../models/user_personal_info.dart';
import '../../../colors/app_colors.dart';
import '../../../style_resource/custom_textstyle.dart';
import '../../../utils/strings_manager.dart';
import '../../custom_widgets/custom_share_button.dart';
import '../common/head_of_popup_widget.dart';
import '../common/jump_arrow.dart';

class PopupSharePost extends StatefulWidget {
  final Post postInfo;
  final UserPersonalInfo publisherInfo;

  const PopupSharePost({
    super.key,
    required this.publisherInfo,
    required this.postInfo,
  });

  @override
  State<PopupSharePost> createState() => _PopupSharePostState();
}

class _PopupSharePostState extends State<PopupSharePost> {
  final TextEditingController messageTextController = TextEditingController();
  final TextEditingController searchTextController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final selectedUsersInfo = ValueNotifier<List<UserPersonalInfo>>([]);
  @override
  Widget build(BuildContext context) {
    bool minimumOfWidth = MediaQuery.of(context).size.width > 700;
    return Center(
      child: SizedBox(
        width: minimumOfWidth ? 550 : double.infinity,
        height: minimumOfWidth ? 650 : double.infinity,
        child: Material(
          color: AppColors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(minimumOfWidth ? 15 : 0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                customDivider(
                  child: TheHeadWidgets(
                      text: StringsManager.share.tr, makeIconsBigger: true),
                ),
                Container(
                  color: AppColors.white,
                  padding: const EdgeInsets.only(left: 15, top: 15),
                  child: Text("To:",
                      style:
                          getBoldStyle(color: AppColors.black, fontSize: 16)),
                ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                          top: 10, bottom: 10, end: 12, start: 18),
                      child: selectedUsersInfo.value.isEmpty
                          ? emptyMessage()
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: scrollController,
                              reverse: true,
                              child: Row(
                                children: [
                                  ...List.generate(
                                    selectedUsersInfo.value.length,
                                    (i) => buildContainer(
                                        selectedUsersInfo.value[i].name, i),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: GestureDetector(
                          onTap: () {
                            double pos = scrollController.offset + 600;
                            scrollController.animateTo(pos,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOutQuart);
                          },
                          child: const ArrowJump(topPadding: true)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: GestureDetector(
                        onTap: () {
                          double pos = scrollController.offset - 600;
                          pos = pos < 0 ? 0 : pos;
                          scrollController.animateTo(pos,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOutQuart);
                        },
                        child: const ArrowJump(
                            isThatBack: false, topPadding: true),
                      ),
                    ),
                  ],
                ),
                Flexible(fit: FlexFit.loose, flex: 1, child: buildUsers()),
                ...textFiledAndShareButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void maxExtentUsersList() {
    scrollController.animateTo(0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutQuart);
  }

  Padding emptyMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 17),
      child: Text(
        "Select users",
        style: getNormalStyle(color: AppColors.grey, fontSize: 15),
      ),
    );
  }

  Widget buildContainer(String selectedUserName, int index) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.transparentBlue,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          children: [
            Center(
              child: Text(
                selectedUserName,
                style: TextStyle(
                    fontSize: 15.0,
                    color: AppColors.blue,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedUsersInfo.value.removeAt(index);
                });
              },
              child: Icon(
                Icons.close_rounded,
                color: AppColors.blue,
              ),
            )
          ],
        ),
      ),
    );
  }

  /// I didn't use the normal way of divider because the height of divider was changing when moving your mouse on it.

  Container customDivider({required Widget child, bool bottomDivider = true}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.transparent,
        border: Border(
          top: !bottomDivider ? divider() : BorderSide.none,
          bottom: bottomDivider ? divider() : BorderSide.none,
        ),
      ),
      child: child,
    );
  }

  BorderSide divider() => const BorderSide(color: AppColors.grey, width: 0.1);

  List<Widget> textFiledAndShareButton() => [
        customDivider(
          bottomDivider: false,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
                start: 20, bottom: 10, end: 20, top: 10),
            child: selectedUsersInfo.value.isNotEmpty
                ? messageField(
                    messageTextController, StringsManager.writeMessage.tr)
                : null,
          ),
        ),
        Padding(
          padding:
              const EdgeInsetsDirectional.only(start: 20, bottom: 20, end: 20),
          child: ValueListenableBuilder(
            valueListenable: selectedUsersInfo,
            builder:
                (context, List<UserPersonalInfo> selectedUsersValue, child) =>
                    CustomShareButton(
              postInfo: widget.postInfo,
              clearTexts: clearTextsController,
              publisherInfo: widget.publisherInfo,
              messageTextController: messageTextController,
              selectedUsersInfo: selectedUsersValue,
              textOfButton: StringsManager.send.tr,
            ),
          ),
        ),
      ];

  clearTextsController(bool clearText) {
    setState(() {
      if (clearText) messageTextController.clear();
    });
  }

  Widget messageField(TextEditingController textController, String hintText) {
    return TextFormField(
      controller: textController,
      cursorColor: AppColors.teal,
      style: getNormalStyle(color: AppColors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: getNormalStyle(color: AppColors.grey),
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
      onChanged: (_) => setState(() {}),
    );
  }

  Widget buildUsers() => SizedBox(
        height: double.infinity,
        child: SendToUsers(
          maxExtentUsersList: maxExtentUsersList,
          freezeListScroll: false,
          publisherInfo: widget.postInfo.publisherInfo!,
          messageTextController: messageTextController,
          postInfo: widget.postInfo,
          clearTexts: clearTextsController,
          selectedUsersInfo: selectedUsersInfo,
          checkBox: true,
        ),
      );
}
