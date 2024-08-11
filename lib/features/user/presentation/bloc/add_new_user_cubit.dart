import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_dharmesh_bloc_demo/injection_container.dart';

import '../../../../models/user_personal_info.dart';
import '../../domain/use_cases/add_new_user_usecase.dart';
import 'add_new_user_state.dart';

class FireStoreAddNewUserCubit extends Cubit<FirestoreAddNewUserState> {
  // final AddNewUserUseCase _addNewUserUseCase;

  FireStoreAddNewUserCubit() : super(CubitInitial());

  static FireStoreAddNewUserCubit get(BuildContext context) =>
      BlocProvider.of(context);

  void addNewUser(UserPersonalInfo newUserInfo) {
    emit(CubitUserAdding());
    locator
        .call<AddNewUserUseCase>()
        .call(params: newUserInfo)
        .then((userInfo) {
      emit(CubitUserAdded());
    }).catchError((e) {
      emit(CubitAddNewUserFailed(e));
    });
  }
}
