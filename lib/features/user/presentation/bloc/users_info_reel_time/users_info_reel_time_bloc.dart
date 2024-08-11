import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart';
import '../../../../../models/user_personal_info.dart';
import '../../../domain/use_cases/getUserInfo/get_all_users_info.dart';
import '../../../domain/use_cases/my_personal_info.dart';

part 'users_info_reel_time_event.dart';

part 'users_info_reel_time_state.dart';

class UsersInfoReelTimeBloc
    extends Bloc<UsersInfoReelTimeEvent, UsersInfoReelTimeState> {
  // final GetMyInfoUseCase _getMyInfoUseCase;
  // final GetAllUsersUseCase _getAllUsersUseCase;

  UsersInfoReelTimeBloc() : super(MyPersonalInfoInitial()) {
    on<LoadMyPersonalInfo>(_onLoadMyPersonalInfo);
    on<UpdateMyPersonalInfo>(_onUpdateMyPersonalInfo);
    on<LoadAllUsersInfoInfo>(_onLoadAllUsersInfoInfo);
    on<UpdateAllUsersInfoInfo>(_onUpdateAllUsersInfoInfo);
  }

  static UsersInfoReelTimeBloc get(BuildContext context) =>
      BlocProvider.of(context);

  UserPersonalInfo? myPersonalInfoInReelTime;
  List<UserPersonalInfo> allUsersInfoInReelTime = [];

  static UserPersonalInfo? getMyInfoInReelTime(BuildContext context) =>
      BlocProvider.of<UsersInfoReelTimeBloc>(context).myPersonalInfoInReelTime;

  Future<void> _onLoadMyPersonalInfo(
      LoadMyPersonalInfo event, Emitter<UsersInfoReelTimeState> emit) async {
    locator.call<GetMyInfoUseCase>().call(params: null).listen(
      (myPersonalInfo) {
        add(UpdateMyPersonalInfo(myPersonalInfo));
      },
    ).onError((e) {
      emit(MyPersonalInfoFailed(e.toString()));
    });
  }

  Future<void> _onUpdateMyPersonalInfo(
      UpdateMyPersonalInfo event, Emitter<UsersInfoReelTimeState> emit) async {
    myPersonalInfoInReelTime = event.myPersonalInfoInReelTime;
    emit(MyPersonalInfoLoaded(
        myPersonalInfoInReelTime: event.myPersonalInfoInReelTime));
  }

  Future<void> _onLoadAllUsersInfoInfo(
      LoadAllUsersInfoInfo event, Emitter<UsersInfoReelTimeState> emit) async {
    locator.call<GetAllUsersUseCase>().call(params: null).listen(
      (allUsersInfo) {
        add(UpdateAllUsersInfoInfo(allUsersInfo));
      },
    ).onError((e) {
      emit(MyPersonalInfoFailed(e.toString()));
    });
  }

  Future<void> _onUpdateAllUsersInfoInfo(UpdateAllUsersInfoInfo event,
      Emitter<UsersInfoReelTimeState> emit) async {
    allUsersInfoInReelTime = event.allUsersInfoInReelTime;
    emit(AllUsersInfoLoaded(
        allUsersInfoInReelTime: event.allUsersInfoInReelTime));
  }
}
