import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../models/user_personal_info.dart';
import '../bloc/user_info_cubit.dart';
import '../screen/personal_profile_page.dart';
import '../screen/user_profile_page.dart';

class WhichProfilePage extends StatelessWidget {
  final String userId;
  final String userName;
  const WhichProfilePage({Key? key, this.userId = '', this.userName = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userId.isNotEmpty) {
      return userId == myPersonalId
          ? PersonalProfilePage(personalId: userId)
          : UserProfilePage(userId: userId);
    } else {
      return Builder(builder: (context) {
        UserPersonalInfo? myPersonalInfo =
            UserInfoCubit.get(context).myPersonalInfo;

        return userName == myPersonalInfo.userName
            ? PersonalProfilePage(
                userName: userName,
                personalId: userId,
              )
            : UserProfilePage(
                userName: userName,
                userId: userId,
              );
      });
    }
  }
}
