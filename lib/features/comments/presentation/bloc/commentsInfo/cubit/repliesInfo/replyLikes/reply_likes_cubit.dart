import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../injection_container.dart';
import '../../../../../../domain/use_cases/comments/remove_like.dart';
import '../../../../../../domain/use_cases/comments/replies/likes/put_like_on_this_reply.dart';

part 'reply_likes_state.dart';

class ReplyLikesCubit extends Cubit<ReplyLikesState> {
  // final PutLikeOnThisReplyUseCase _putLikeOnThisReplyUseCase;
  // final RemoveLikeOnThisReplyUseCase _removeLikeOnThisReplyUseCase;
  ReplyLikesCubit(
      // this._putLikeOnThisReplyUseCase, this._removeLikeOnThisReplyUseCase
      )
      : super(ReplyLikesInitial());

  static ReplyLikesCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> putLikeOnThisReply(
      {required String replyId, required String myPersonalId}) async {
    emit(CubitReplyLikesLoading());
    await locator
        .call<PutLikeOnThisReplyUseCase>()
        .call(paramsOne: replyId, paramsTwo: myPersonalId)
        .then((_) {
      emit(CubitReplyLikesLoaded());
    }).catchError((e) {
      emit(CubitReplyLikesFailed(e.toString()));
    });
  }

  Future<void> removeLikeOnThisReply(
      {required String replyId, required String myPersonalId}) async {
    emit(CubitReplyLikesLoading());

    await locator
        .call<RemoveLikeOnThisCommentUseCase>()
        .call(paramsOne: replyId, paramsTwo: myPersonalId)
        .then((_) {
      emit(CubitReplyLikesLoaded());
    }).catchError((e) {
      emit(CubitReplyLikesFailed(e.toString()));
    });
  }
}
