import '../../../../models/comment.dart';
import '../../domain/repository/firestore_reply_repository.dart';
import '../data_sources/remote/firestore_comments/comments_network_db_impl.dart';
import '../data_sources/remote/firestore_reply/firestore_reply_network_db.dart';

class FireStoreRepliesRepositoryImpl implements FireStoreReplyRepository {
  final FireStoreReplyNetworkDb firestoreReply;
  FireStoreRepliesRepositoryImpl({required this.firestoreReply});

  final firestoreComment = CommentsNetworkDbImpl();

  @override
  Future<Comment> replyOnThisComment({required Comment replyInfo}) async {
    try {
      String replyId =
          await firestoreReply.replyOnThisComment(replyInfo: replyInfo);

      Comment theReplyInfo =
          await firestoreReply.getReplyInfo(replyId: replyId);
      await firestoreComment.putReplyOnThisComment(
          commentId: theReplyInfo.parentCommentId,
          replyId: theReplyInfo.commentUid);

      return theReplyInfo;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> putLikeOnThisReply(
      {required String replyId, required String myPersonalId}) async {
    try {
      await firestoreReply.putLikeOnThisReply(
          replyId: replyId, myPersonalId: myPersonalId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> removeLikeOnThisReply(
      {required String replyId, required String myPersonalId}) async {
    try {
      await firestoreReply.removeLikeOnThisReply(
          replyId: replyId, myPersonalId: myPersonalId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<Comment>> getSpecificReplies({required String commentId}) async {
    try {
      List? repliesIds =
          await firestoreComment.getRepliesOfComments(commentId: commentId);
      List<Comment> theRepliesInfo =
          await firestoreReply.getSpecificReplies(repliesIds: repliesIds!);
      return theRepliesInfo;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
