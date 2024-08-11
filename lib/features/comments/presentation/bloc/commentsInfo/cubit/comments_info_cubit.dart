import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../injection_container.dart';
import '../../../../../../models/comment.dart';
import '../../../../domain/use_cases/comments/add_comment_use_case.dart';
import '../../../../domain/use_cases/comments/getComment/get_all_comment.dart';

part 'comments_info_state.dart';

class CommentsInfoCubit extends Cubit<CommentsInfoState> {
  // final GetSpecificCommentsUseCase _getSpecificCommentsUseCase;
  // final AddCommentUseCase _addCommentUseCase;
  List<Comment> commentsOfThePost = [];

  CommentsInfoCubit(
      // this._getSpecificCommentsUseCase, this._addCommentUseCase
      )
      : super(CommentsInfoInitial());

  static CommentsInfoCubit get(BuildContext context) =>
      BlocProvider.of(context);

  Future<void> getSpecificComments({required String postId}) async {
    emit(CubitCommentsInfoLoading());
    await locator
        .call<GetSpecificCommentsUseCase>()
        .call(params: postId)
        .then((commentsInfo) {
      commentsOfThePost = commentsInfo;
      emit(CubitCommentsInfoLoaded(commentsInfo));
    }).catchError((e) {
      emit(CubitCommentsInfoFailed(e.toString()));
    });
  }

  Future<void> addComment({required Comment commentInfo}) async {
    emit(CubitCommentsInfoLoading());
    await locator
        .call<AddCommentUseCase>()
        .call(params: commentInfo)
        .then((updatedCommentInfo) {
      commentsOfThePost = [updatedCommentInfo] + commentsOfThePost;
      emit(CubitCommentsInfoLoaded(commentsOfThePost));
    }).catchError((e) {
      emit(CubitCommentsInfoFailed(e.toString()));
    });
  }
}
