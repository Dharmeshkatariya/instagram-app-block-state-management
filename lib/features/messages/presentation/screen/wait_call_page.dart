import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_dharmesh_bloc_demo/features/messages/presentation/screen/video_call_page.dart';

import '../../../../core/colors/app_colors.dart';
import '../../../../core/style_resource/custom_textstyle.dart';
import '../../../../models/user_personal_info.dart';
import '../bloc/callingRooms/bloc/calling_status_bloc.dart';
import '../bloc/callingRooms/calling_rooms_cubit.dart';

class VideoCallPage extends StatelessWidget {
  final List<UserPersonalInfo> usersInfo;
  final UserPersonalInfo myPersonalInfo;

  const VideoCallPage({
    super.key,
    required this.usersInfo,
    required this.myPersonalInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.lowOpacityGrey,
      body: SafeArea(
        child: BlocBuilder<CallingRoomsCubit, CallingRoomsState>(
          buildWhen: (previous, current) =>
              previous != current && current is CallingRoomsLoaded,
          bloc: CallingRoomsCubit.get(context)
            ..createCallingRoom(
                myPersonalInfo: myPersonalInfo, callThoseUsersInfo: usersInfo),
          builder: (callingRoomContext, callingRoomState) {
            if (callingRoomState is CallingRoomsLoaded) {
              return callingRoomsLoaded(callingRoomState, callingRoomContext);
            } else if (callingRoomState is CallingRoomsFailed) {
              return whichFailedText(callingRoomState, callingRoomContext);
            } else {
              return callingLoadingPage();
            }
          },
        ),
      ),
    );
  }

  Widget callingRoomsLoaded(
      CallingRoomsLoaded roomsState, BuildContext context) {
    return BlocBuilder<CallingStatusBloc, CallingStatusState>(
      bloc: CallingStatusBloc.get(context)
        ..add(LoadCallingStatus(roomsState.channelId)),
      builder: (context, callingStatusState) {
        bool isAllUsersCanceled = callingStatusState is CallingStatusLoaded &&
            callingStatusState.callingStatus == false;

        bool isThereAnyProblem = callingStatusState is CallingStatusFailed;

        if (isAllUsersCanceled || isThereAnyProblem) {
          return canceledText(roomsState, context);
        } else {
          return callPage(roomsState);
        }
      },
    );
  }

  Widget callPage(CallingRoomsLoaded roomsState) {
    return CallPage(
      channelName: roomsState.channelId,
      role: ClientRole.Broadcaster,
      userCallingType: UserCallingType.sender,
      usersInfo: usersInfo,
    );
  }

  Widget canceledText(CallingRoomsLoaded roomsState, BuildContext context) {
    List<dynamic> usersIds = [];
    usersInfo.where((element) {
      usersIds.add(element.userId);
      return true;
    }).toList();
    CallingRoomsCubit.get(context)
        .deleteTheRoom(channelId: roomsState.channelId, usersIds: usersIds);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 2)).then((value) {
        Navigator.of(context).maybePop();
      });
    });
    return const Center(
        child: Text("Canceled...",
            style: TextStyle(fontSize: 20, color: Colors.black87)));
  }

  Widget whichFailedText(CallingRoomsFailed state, BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 1)).then((value) {
        Navigator.of(context).maybePop();
      });
    });
    if (state.error == "Busy") {
      String message = usersInfo.length > 1
          ? "They are all busy..."
          : '${usersInfo[0].name} is Busy...';
      return Center(child: Text(message));
    } else {
      return const Center(child: Text("Call ended..."));
    }
  }

  Widget callingLoadingPage() {
    return Center(
      child: Text("Connecting...",
          style: getNormalStyle(color: AppColors.black, fontSize: 25)),
    );
  }
}
