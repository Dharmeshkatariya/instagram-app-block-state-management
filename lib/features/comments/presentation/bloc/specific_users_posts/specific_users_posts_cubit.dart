import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_dharmesh_bloc_demo/injection_container.dart';

import '../../../domain/use_cases/get/get_specific_users_posts.dart';

part 'specific_users_posts_state.dart';

class SpecificUsersPostsCubit extends Cubit<SpecificUsersPostsState> {
  // GetSpecificUsersPostsUseCase getSpecificUsersPostsUseCase;
  List usersPostsInfo = [];

  SpecificUsersPostsCubit() : super(SpecificUsersPostsInitial());

  static SpecificUsersPostsCubit get(BuildContext context) =>
      BlocProvider.of(context);

  Future<void> getSpecificUsersPostsInfo(
      {required List<dynamic> usersIds}) async {
    emit(SpecificUsersPostsLoading());
    await locator
        .call<GetSpecificUsersPostsUseCase>()
        .call(params: usersIds)
        .then((specificPostsInfo) {
      usersPostsInfo = specificPostsInfo;
      emit(SpecificUsersPostsLoaded(specificPostsInfo));
    }).catchError((e) {
      usersPostsInfo = [];
      emit(SpecificUsersPostsFailed(e.toString()));
    });
  }
}
