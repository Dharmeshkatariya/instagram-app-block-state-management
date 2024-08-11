import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_dharmesh_bloc_demo/injection_container.dart';

import '../../../../models/user_personal_info.dart';
import '../../../messages/domain/use_cases/single_message/get_chat_users_info.dart';
import '../../domain/entities/sender_info.dart';
import '../../domain/entities/specific_user.dart';
import '../../domain/use_cases/getUserInfo/get_followers_and_followings_usecase.dart';
import '../../domain/use_cases/getUserInfo/get_specific_users_usecase.dart';

part 'users_info_state.dart';

class UsersInfoCubit extends Cubit<UsersInfoState> {
  // final GetFollowersAndFollowingsUseCase getFollowersAndFollowingsUseCase;
  // final GetSpecificUsersUseCase getSpecificUsersUseCase;
  // final GetChatUsersInfoAddMessageUseCase _getChatUsersInfoAddMessageUseCase;

  UsersInfoCubit(
      // this.getFollowersAndFollowingsUseCase,
      // this.getSpecificUsersUseCase, this._getChatUsersInfoAddMessageUseCase
      //
      )
      : super(UsersInfoInitial());
  static UsersInfoCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> getFollowersAndFollowingsInfo(
      {required List<dynamic> followersIds,
      required List<dynamic> followingsIds}) async {
    emit(CubitFollowersAndFollowingsLoading());
    await locator
        .call<GetFollowersAndFollowingsUseCase>()

        // await getFollowersAndFollowingsUseCase
        .call(paramsOne: followersIds, paramsTwo: followingsIds)
        .then((specificUsersInfo) {
      emit(CubitFollowersAndFollowingsLoaded(specificUsersInfo));
    }).catchError((e) {
      emit(CubitGettingSpecificUsersFailed(e.toString()));
    });
  }

  Future<void> getSpecificUsersInfo({required List<dynamic> usersIds}) async {
    emit(CubitFollowersAndFollowingsLoading());
    await locator
        .call<GetSpecificUsersUseCase>()
        .call(params: usersIds)
        .then((usersIds) {
      emit(CubitGettingSpecificUsersLoaded(usersIds));
    }).catchError((e) {
      emit(CubitGettingSpecificUsersFailed(e.toString()));
    });
  }

  Future<void> getChatUsersInfo(
      {required UserPersonalInfo myPersonalInfo}) async {
    emit(CubitGettingChatUsersInfoLoading());
    await locator
        .call<GetChatUsersInfoAddMessageUseCase>()
        .call(params: myPersonalInfo)
        .then((usersInfo) {
      emit(CubitGettingChatUsersInfoLoaded(usersInfo));
    }).catchError((e) {
      emit(CubitGettingSpecificUsersFailed(e.toString()));
    });
  }
}
