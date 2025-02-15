import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_dharmesh_bloc_demo/injection_container.dart';

import '../../../../core/asset/asset.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/style_resource/custom_textstyle.dart';
import '../../../../core/widget/circle_avatar_image/circle_avatar_of_profile_image.dart';
import '../../../../models/user_personal_info.dart';
import '../../../user/domain/entities/sender_info.dart';
import '../../../user/presentation/bloc/user_info_cubit.dart';
import '../bloc/message/bloc/message_bloc.dart';
import '../widgets/chat_messages.dart';
import '../widgets/list_of_messages.dart';

class MessagesForWeb extends StatefulWidget {
  final UserPersonalInfo? selectedTextingUser;

  const MessagesForWeb({super.key, this.selectedTextingUser});

  @override
  State<MessagesForWeb> createState() => _MessagesForWebState();
}

class _MessagesForWebState extends State<MessagesForWeb> {
  late UserPersonalInfo? selectedTextingUser;
  late UserPersonalInfo myPersonalInfo;
  late SenderInfo senderInfo;

  @override
  initState() {
    selectedTextingUser = widget.selectedTextingUser;
    if (selectedTextingUser != null) {
      senderInfo = SenderInfo(
          receiversInfo: [selectedTextingUser!],
          receiversIds: [selectedTextingUser!.userId]);
    }
    myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 950,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(
                color: AppColors.lowOpacityGrey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Row(
              children: [
                messages(),
                chatting(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget chatting() {
    if (selectedTextingUser == null) {
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "There is no selected massage",
              style: getMediumStyle(color: AppColors.black),
            ),
          ],
        ),
      );
    } else {
      return Expanded(
        child: Column(
          children: [
            appBarOfChatting(),
            Expanded(child: chatMessages()),
          ],
        ),
      );
    }
  }

  Widget chatMessages() {
    return BlocProvider<MessageBloc>(
      create: (context) => locator<MessageBloc>(),
      child: ChatMessages(messageDetails: senderInfo),
    );
  }

  Container appBarOfChatting() {
    bool isThatGroup = senderInfo.lastMessage?.isThatGroup ?? false;

    return Container(
      height: 70,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.lowOpacityGrey,
            width: 1.0,
          ),
        ),
      ),
      child: selectedTextingUser != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 25),
                    if (isThatGroup) ...[
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.only(top: 15, end: 12),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: -4,
                              left: 5,
                              child: CircleAvatarOfProfileImage(
                                bodyHeight: 330,
                                userInfo: senderInfo.receiversInfo![0],
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CircleAvatarOfProfileImage(
                                bodyHeight: 330,
                                userInfo: senderInfo.receiversInfo![1],
                              ),
                            ),
                          ],
                        ),
                      )
                    ] else ...[
                      CircleAvatarOfProfileImage(
                        bodyHeight: 350,
                        userInfo: senderInfo.receiversInfo![0],
                      ),
                    ],
                    const SizedBox(width: 15),
                    buildText(),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      phone,
                      height: 27,
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).focusColor, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 20),
                    SvgPicture.asset(
                      videoPoint,
                      height: 25,
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).focusColor, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 25),
                  ],
                ),
              ],
            )
          : null,
    );
  }

  Text buildText() {
    bool isThatGroup = senderInfo.lastMessage?.isThatGroup ?? false;
    List<UserPersonalInfo> receiverInfo = senderInfo.receiversInfo!;
    String text = isThatGroup
        ? "${receiverInfo[0].name}, ${receiverInfo[1].name}${receiverInfo.length > 2 ? ", ..." : ""}"
        : receiverInfo[0].name;
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: getNormalStyle(color: Theme.of(context).focusColor),
    );
  }

  Container messages() {
    return Container(
      width: 350,
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(
            color: AppColors.lowOpacityGrey,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        children: [
          appBarOfMessages(),
          Flexible(
            child: SingleChildScrollView(
              child: ListOfMessages(
                selectChatting: selectChatting,
                additionalUser: selectedTextingUser,
                freezeListView: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void selectChatting(SenderInfo userInfo) {
    setState(() {
      selectedTextingUser = null;
      selectedTextingUser = userInfo.receiversInfo![0];
      senderInfo = userInfo;
    });
  }

  Container appBarOfMessages() {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.lowOpacityGrey,
            width: 1.0,
          ),
        ),
      ),
      child: Center(
        child: Text(myPersonalInfo.userName,
            style: getMediumStyle(color: AppColors.black, fontSize: 17)),
      ),
    );
  }
}
