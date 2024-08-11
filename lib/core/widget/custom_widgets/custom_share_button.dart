import 'package:flutter/material.dart';

import '../../../features/messages/presentation/bloc/message/cubit/message_cubit.dart';
import '../../../features/user/presentation/bloc/user_info_cubit.dart';
import '../../../models/message.dart';
import '../../../models/post/post.dart';
import '../../../models/user_personal_info.dart';
import '../../colors/app_colors.dart';
import '../../constants/constants.dart';
import '../../utils/date_of_now.dart';
import 'custom_circulars_progress.dart';

class CustomShareButton extends StatefulWidget {
  final Post postInfo;
  final String textOfButton;
  final UserPersonalInfo publisherInfo;
  final TextEditingController messageTextController;
  final List<UserPersonalInfo> selectedUsersInfo;
  final ValueChanged<bool> clearTexts;
  const CustomShareButton({
    super.key,
    required this.publisherInfo,
    required this.clearTexts,
    required this.textOfButton,
    required this.messageTextController,
    required this.selectedUsersInfo,
    required this.postInfo,
  });

  @override
  State<CustomShareButton> createState() => _CustomShareButtonState();
}

class _CustomShareButtonState extends State<CustomShareButton> {
  late UserPersonalInfo myPersonalInfo;
  final isThatLoading = ValueNotifier(false);
  @override
  void initState() {
    myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Builder(builder: (context) {
        MessageCubit messageCubit = MessageCubit.get(context);
        return InkWell(
          onTap: () async {
            isThatLoading.value = true;
            for (final selectedUser in widget.selectedUsersInfo) {
              await messageCubit.sendMessage(
                messageInfo:
                    createSharedMessage(widget.postInfo.blurHash, selectedUser),
              );
              if (widget.messageTextController.text.isNotEmpty) {
                await messageCubit.sendMessage(
                    messageInfo: createCaptionMessage(selectedUser));
              }
            }
            // ignore: use_build_context_synchronously
            await Navigator.of(context).maybePop();
            widget.clearTexts(true);
          },
          child: buildDoneButton(),
        );
      }),
    );
  }

  Message createCaptionMessage(UserPersonalInfo userInfoWhoIShared) {
    return Message(
      datePublished: DateReformat.dateOfNow(),
      message: widget.messageTextController.text,
      senderId: myPersonalId,
      senderInfo: myPersonalInfo,
      blurHash: "",
      receiversIds: [userInfoWhoIShared.userId],
      isThatImage: false,
    );
  }

  Message createSharedMessage(
      String blurHash, UserPersonalInfo userInfoWhoIShared) {
    bool isThatImage = widget.postInfo.isThatImage;
    String imageUrl = isThatImage
        ? widget.postInfo.imagesUrls.length > 1
            ? widget.postInfo.imagesUrls[0]
            : widget.postInfo.postUrl
        : widget.postInfo.coverOfVideoUrl;
    dynamic userId = userInfoWhoIShared.userId;
    return Message(
      datePublished: DateReformat.dateOfNow(),
      message: widget.postInfo.caption,
      senderId: myPersonalId,
      senderInfo: myPersonalInfo,
      blurHash: blurHash,
      receiversIds: [userId],
      isThatImage: true,
      isThatVideo: !isThatImage,
      sharedPostId: widget.postInfo.postUid,
      imageUrl: imageUrl,
      isThatPost: true,
      ownerOfSharedPostId: widget.publisherInfo.userId,
      multiImages: widget.postInfo.imagesUrls.length > 1,
    );
  }

  Widget buildDoneButton() {
    return ValueListenableBuilder(
      valueListenable: isThatLoading,
      builder: (context, bool isThatLoadingValue, child) => Container(
        height: 50.0,
        width: double.infinity,
        padding: const EdgeInsetsDirectional.only(start: 17, end: 17),
        decoration: BoxDecoration(
          color: isThatLoadingValue ? AppColors.lightBlue : AppColors.blue,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: !isThatLoadingValue
              ? Text(
                  widget.textOfButton,
                  style: const TextStyle(
                      fontSize: 15.0,
                      color: AppColors.white,
                      fontWeight: FontWeight.w500),
                )
              : circularProgress(),
        ),
      ),
    );
  }

  Widget circularProgress() {
    return const Center(
      child: SizedBox(
          height: 20,
          width: 20,
          child: ThineCircularProgress(color: AppColors.white, strokeWidth: 2)),
    );
  }
}
