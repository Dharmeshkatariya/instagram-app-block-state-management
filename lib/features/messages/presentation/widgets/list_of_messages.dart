import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/colors/app_colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/routes/getnav.dart';
import '../../../../core/style_resource/custom_textstyle.dart';
import '../../../../core/translations/app_lang.dart';
import '../../../../core/utils/date_of_now.dart';
import '../../../../core/utils/strings_manager.dart';
import '../../../../core/utils/toast_show.dart';
import '../../../../core/widget/circle_avatar_image/circle_avatar_of_profile_image.dart';
import '../../../../core/widget/custom_widgets/custom_circulars_progress.dart';
import '../../../../core/widget/custom_widgets/custom_linears_progress.dart';
import '../../../../core/widget/custom_widgets/custom_smart_refresh.dart';
import '../../../../injection_container.dart';
import '../../../../models/message.dart';
import '../../../../models/user_personal_info.dart';
import '../../../user/domain/entities/sender_info.dart';
import '../../../user/presentation/bloc/user_info_cubit.dart';
import '../../../user/presentation/bloc/users_info_cubit.dart';
import '../../../user/presentation/bloc/users_info_reel_time/users_info_reel_time_bloc.dart';
import '../bloc/message/bloc/message_bloc.dart';
import '../screen/chatting_page.dart';

class ListOfMessages extends StatefulWidget {
  final ValueChanged<SenderInfo>? selectChatting;
  final UserPersonalInfo? additionalUser;
  final bool freezeListView;
  const ListOfMessages({
    Key? key,
    this.selectChatting,
    this.freezeListView = false,
    this.additionalUser,
  }) : super(key: key);

  @override
  State<ListOfMessages> createState() => _ListOfMessagesState();
}

class _ListOfMessagesState extends State<ListOfMessages> {
  late UserPersonalInfo myPersonalInfo;

  @override
  void initState() {
    myPersonalInfo = UsersInfoReelTimeBloc.getMyInfoInReelTime(context) ??
        UserInfoCubit.getMyPersonalInfo(context);
    super.initState();
  }

  Future<void> onRefreshData(int index) async {
    myPersonalInfo = UsersInfoReelTimeBloc.getMyInfoInReelTime(context) ??
        UserInfoCubit.getMyPersonalInfo(context);
    await UsersInfoCubit.get(context)
        .getChatUsersInfo(myPersonalInfo: myPersonalInfo);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.maxFinite,
      child: CustomSmartRefresh(
          onRefreshData: onRefreshData, child: buildBlocBuilder()),
    );
  }

  BlocBuilder<UsersInfoCubit, UsersInfoState> buildBlocBuilder() {
    final mediaQuery = MediaQuery.of(context);
    final bodyHeight = isThatMobile
        ? mediaQuery.size.height -
            AppBar().preferredSize.height -
            mediaQuery.padding.top
        : 500;
    return BlocBuilder<UsersInfoCubit, UsersInfoState>(
      bloc: UsersInfoCubit.get(context)
        ..getChatUsersInfo(myPersonalInfo: myPersonalInfo),
      buildWhen: (previous, current) =>
          previous != current && current is CubitGettingChatUsersInfoLoaded,
      builder: (context, state) {
        if (state is CubitGettingChatUsersInfoLoaded) {
          bool isThatUserExist = false;
          if (widget.additionalUser != null) {
            state.usersInfo.where((element) {
              bool isUserExist = ((element.receiversIds
                          ?.contains(widget.additionalUser?.userId)) ??
                      false) &&
                  !(element.lastMessage?.isThatGroup ?? true);
              if (!isUserExist) isThatUserExist = true;
              return true;
            }).toList();
          }
          List<SenderInfo> usersInfo = state.usersInfo;
          if (!isThatUserExist && widget.additionalUser != null) {
            SenderInfo senderInfo =
                SenderInfo(receiversInfo: [widget.additionalUser!]);
            usersInfo.add(senderInfo);
          }
          if (usersInfo.isEmpty) {
            return Center(
              child: Text(StringsManager.noUsers.tr,
                  style: getNormalStyle(color: Theme.of(context).focusColor)),
            );
          } else {
            return buildListView(usersInfo, bodyHeight);
          }
        } else if (state is CubitGettingSpecificUsersFailed) {
          ToastShow.toastStateError(state);
          return Text(
            StringsManager.somethingWrong,
            style: getNormalStyle(color: Theme.of(context).focusColor),
          );
        } else {
          return isThatMobile
              ? const ThineCircularProgress()
              : const ThineLinearProgress();
        }
      },
    );
  }

  ListView buildListView(List<SenderInfo> usersInfo, num bodyHeight) {
    bool isThatEnglish = AppLanguage.getInstance().isLangEnglish;
    return ListView.separated(
        physics: widget.freezeListView
            ? const NeverScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        primary: !widget.freezeListView,
        shrinkWrap: widget.freezeListView,
        itemCount: usersInfo.length,
        itemBuilder: (context, index) {
          Message? theLastMessage = usersInfo[index].lastMessage;
          bool isThatGroup = usersInfo[index].lastMessage?.isThatGroup ?? false;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: GestureDetector(
              onTap: () {
                if (widget.selectChatting != null) {
                  widget.selectChatting!(usersInfo[index]);
                } else {
                  Go(context).push(
                      page: BlocProvider<MessageBloc>(
                    create: (context) => locator<MessageBloc>(),
                    child: ChattingPage(messageDetails: usersInfo[index]),
                  ));
                }
              },
              child: Row(
                children: [
                  if (isThatGroup) ...[
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                          top: 15,
                          end: isThatEnglish ? 12 : 3,
                          start: isThatEnglish ? (isThatMobile ? 5 : 0) : 15),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -12,
                            left: 8,
                            child: CircleAvatarOfProfileImage(
                              bodyHeight: bodyHeight * 0.7,
                              userInfo: usersInfo[index].receiversInfo![0],
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: CircleAvatarOfProfileImage(
                              bodyHeight: bodyHeight * 0.7,
                              userInfo: usersInfo[index].receiversInfo![1],
                            ),
                          ),
                        ],
                      ),
                    )
                  ] else ...[
                    CircleAvatarOfProfileImage(
                      bodyHeight: bodyHeight * 0.85,
                      userInfo: usersInfo[index].receiversInfo![0],
                    ),
                  ],
                  const SizedBox(width: 15),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildText(usersInfo, index, context),
                        if (theLastMessage != null) ...[
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                    theLastMessage.message.isEmpty
                                        ? (theLastMessage.imageUrl.isEmpty
                                            ? StringsManager.recordedSent.tr
                                            : StringsManager.photoSent.tr)
                                        : theLastMessage.message,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style:
                                        getNormalStyle(color: AppColors.grey)),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                  DateReformat.oneDigitFormat(
                                      theLastMessage.datePublished),
                                  style: getNormalStyle(color: AppColors.grey)),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 20));
  }

  Text buildText(List<SenderInfo> usersInfo, int index, BuildContext context) {
    bool isThatGroup = usersInfo[index].lastMessage?.isThatGroup ?? false;
    List<UserPersonalInfo> receiverInfo = usersInfo[index].receiversInfo!;
    String text = isThatGroup
        ? "${receiverInfo[0].name}, ${receiverInfo[1].name}${receiverInfo.length > 2 ? ", ..." : ""}"
        : receiverInfo[0].name;
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: getNormalStyle(color: Theme.of(context).focusColor),
    );
  }
}
