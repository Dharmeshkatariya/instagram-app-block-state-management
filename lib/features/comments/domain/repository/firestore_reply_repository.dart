import '../../../../models/comment.dart';

abstract class FireStoreReplyRepository {
  Future<Comment> replyOnThisComment({required Comment replyInfo});
  Future<void> putLikeOnThisReply(
      {required String replyId, required String myPersonalId});
  Future<void> removeLikeOnThisReply(
      {required String replyId, required String myPersonalId});
  Future<List<Comment>> getSpecificReplies({required String commentId});
}
