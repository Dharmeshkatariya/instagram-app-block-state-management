import '../../../../../../models/comment.dart';

abstract class FireStoreReplyNetworkDb {
  Future<String> replyOnThisComment({required Comment replyInfo});
  Future<void> putLikeOnThisReply(
      {required String replyId, required String myPersonalId});

  Future<void> removeLikeOnThisReply(
      {required String replyId, required String myPersonalId});

  Future<List<Comment>> getSpecificReplies({required List<dynamic> repliesIds});

  Future<Comment> getReplyInfo({required String replyId});
}
