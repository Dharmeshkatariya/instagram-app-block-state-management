import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_dharmesh_bloc_demo/features/messages/presentation/screen/video_call_page.dart';

import '../../../../core/colors/app_colors.dart';
import '../../../../core/routes/getnav.dart';
import '../../../../core/style_resource/custom_textstyle.dart';
import '../../../../models/user_personal_info.dart';
import '../../../user/presentation/bloc/user_info_cubit.dart';
import '../../domain/entities/calling_status.dart';
import '../bloc/callingRooms/calling_rooms_cubit.dart';

class CallingRingingPage extends StatefulWidget {
  final String channelId;
  final VoidCallback clearMoving;
  const CallingRingingPage(
      {super.key, required this.channelId, required this.clearMoving});

  @override
  State<CallingRingingPage> createState() => _CallingRingingPageState();
}

class _CallingRingingPageState extends State<CallingRingingPage> {
  bool pop = false;
  @override
  void dispose() {
    widget.clearMoving();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey,
      body: SafeArea(
        child: BlocBuilder<CallingRoomsCubit, CallingRoomsState>(
          bloc: CallingRoomsCubit.get(context)
            ..getUsersInfoInThisRoom(channelId: widget.channelId),
          builder: (context, state) {
            if (pop) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() => pop = false);
                Navigator.of(context).maybePop();
              });
            }
            if (state is UsersInfoInRoomLoaded) {
              return callingLoadingPage(state.usersInfo);
            } else {
              return waitingText();
            }
          },
        ),
      ),
    );
  }

  Future<void> onTapAcceptButton() async {
    UserPersonalInfo myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    await CallingRoomsCubit.get(context).joinToRoom(
        channelId: widget.channelId, myPersonalInfo: myPersonalInfo);
    if (!mounted) return;

    await Go(context).push(
      page: CallPage(
        channelName: widget.channelId,
        role: ClientRole.Broadcaster,
        userCallingType: UserCallingType.receiver,
      ),
      withoutRoot: false,
    );
    WidgetsBinding.instance
        .addPostFrameCallback((_) => setState(() => pop = true));
  }

  Future<void> onTapCancelButton() async {
    UserPersonalInfo myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    await CallingRoomsCubit.get(context).leaveTheRoom(
      userId: myPersonalInfo.userId,
      channelId: widget.channelId,
      isThatAfterJoining: false,
    );
    if (!mounted) return;
    Navigator.of(context).maybePop();
  }

  Widget waitingText() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Someone calling you",
            style: getNormalStyle(color: AppColors.white),
          ),
          Text(
            "Please wait for loaded...",
            style: getNormalStyle(color: AppColors.white),
          ),
        ],
      ),
    );
  }

  Widget callingLoadingPage(List<UsersInfoInCallingRoom> userInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(height: 100),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(userInfo[0].profileImageUrl!),
            ),
            const SizedBox(height: 30),
            Text(userInfo[0].name!,
                style: getNormalStyle(color: AppColors.white, fontSize: 25)),
            const SizedBox(height: 10),
            Text('Calling...',
                style: getNormalStyle(color: AppColors.white, fontSize: 16.5)),
          ],
        ),
        const Spacer(),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            GestureDetector(
              onTap: onTapCancelButton,
              child: CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.red,
                child: const Icon(
                  Icons.call_end,
                  color: Colors.white,
                  size: 35.0,
                ),
              ),
            ),
            GestureDetector(
              onTap: onTapAcceptButton,
              child: const CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.green,
                child: Icon(
                  Icons.call,
                  color: Colors.white,
                  size: 35.0,
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}
