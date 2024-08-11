import '../../../../../../models/comment.dart';

abstract class CommentsNetworkDb {
  Future<String> addComment({required Comment commentInfo});

  Future<void> putLikeOnThisComment(
      {required String commentId, required String myPersonalId});

  Future<void> removeLikeOnThisComment(
      {required String commentId, required String myPersonalId});

  Future<void> putReplyOnThisComment({
    required String commentId,
    required String replyId,
  });

  Future<List<Comment>> getSpecificComments(
      {required List<dynamic> commentsIds});

  Future<Comment> getCommentInfo({required String commentId});

  Future<List<dynamic>?> getRepliesOfComments({required String commentId});
}
