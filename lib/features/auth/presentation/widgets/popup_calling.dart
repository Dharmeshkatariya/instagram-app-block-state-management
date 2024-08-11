import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/routes/getnav.dart';
import '../../../../core/screens/mobile_screen_layout.dart';
import '../../../messages/presentation/screen/ringing_page.dart';
import '../../../user/presentation/bloc/users_info_reel_time/users_info_reel_time_bloc.dart';

class PopupCalling extends StatefulWidget {
  final String userId;

  const PopupCalling(this.userId, {super.key});

  @override
  State<PopupCalling> createState() => _PopupCallingState();
}

class _PopupCallingState extends State<PopupCalling> {
  bool isHeMoved = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersInfoReelTimeBloc, UsersInfoReelTimeState>(
      bloc: UsersInfoReelTimeBloc.get(context)..add(LoadMyPersonalInfo()),
      builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (state is MyPersonalInfoLoaded &&
              !amICalling &&
              state.myPersonalInfoInReelTime.channelId.isNotEmpty) {
            if (!isHeMoved) {
              isHeMoved = true;
              Go(context).push(
                  page: CallingRingingPage(
                      channelId: state.myPersonalInfoInReelTime.channelId,
                      clearMoving: clearMoving),
                  withoutRoot: false);
            }
          }
        });
        return MobileScreenLayout(widget.userId);
      },
    );
  }

  clearMoving() {
    isHeMoved = false;
  }
}
