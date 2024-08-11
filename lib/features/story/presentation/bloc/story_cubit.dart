import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_dharmesh_bloc_demo/injection_container.dart';

import '../../../../models/post/story.dart';
import '../../../../models/user_personal_info.dart';
import '../../domain/use_cases/create_story.dart';
import '../../domain/use_cases/delete_story.dart';
import '../../domain/use_cases/get_specific_stories.dart';
import '../../domain/use_cases/get_stories_info.dart';

part 'story_state.dart';

class StoryCubit extends Cubit<StoryState> {
  // final CreateStoryUseCase _createStoryUseCase;
  // final GetStoriesInfoUseCase _getStoriesInfoUseCase;
  // final GetSpecificStoriesInfoUseCase _getSpecificStoriesInfoUseCase;
  // final DeleteStoryUseCase _deleteStoryUseCase;
  String storyId = '';

  StoryCubit(
      // this._createStoryUseCase, this._getStoriesInfoUseCase,
      // this._deleteStoryUseCase, this._getSpecificStoriesInfoUseCase

      )
      : super(StoryInitial());

  static StoryCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> createStory(Story storyInfo, Uint8List file) async {
    emit(CubitStoryLoading());

    await locator
        .call<CreateStoryUseCase>()
        .call(paramsOne: storyInfo, paramsTwo: file)
        .then((storyId) {
      this.storyId = storyId;
      emit(CubitStoryLoaded(storyId));
      return storyId;
    }).catchError((e) {
      emit(CubitStoryFailed(e));
      return "Cubit Story Failed";
    });
  }

  Future<void> getStoriesInfo(
      {required List<dynamic> usersIds,
      required UserPersonalInfo myPersonalInfo}) async {
    if (!usersIds.contains(myPersonalInfo.userId)) {
      usersIds = [myPersonalInfo.userId] + usersIds;
    }
    emit(CubitStoryLoading());
    await locator
        .call<GetStoriesInfoUseCase>()
        .call(params: usersIds)
        .then((updatedUsersInfo) {
      emit(CubitStoriesInfoLoaded(updatedUsersInfo));
    }).catchError((e) {
      emit(CubitStoryFailed(e));
    });
  }

  Future<void> getSpecificStoriesInfo(
      {required UserPersonalInfo userInfo}) async {
    emit(CubitStoryLoading());
    await locator
        .call<GetSpecificStoriesInfoUseCase>()
        .call(params: userInfo)
        .then((updatedUserInfo) {
      emit(SpecificStoriesInfoLoaded(updatedUserInfo));
    }).catchError((e) {
      emit(CubitStoryFailed(e));
    });
  }

  Future<void> deleteStory({required String storyId}) async {
    emit(CubitDeletingStoryLoading());
    await locator.call<DeleteStoryUseCase>().call(params: storyId).then((_) {
      emit(CubitDeletingStoryLoaded());
    }).catchError((e) {
      emit(CubitStoryFailed(e));
    });
  }
}
