import '../../../../models/comment.dart';
import '../../domain/repository/firestore_comments_repository.dart';
import '../data_sources/remote/firestore_comments/comments_network_db.dart';
import '../data_sources/remote/firestore_comments/comments_network_db_impl.dart';
import '../data_sources/remote/firestore_post/firestore_post_network_db_impl.dart';

class FireStoreCommentRepositoryImpl implements FireStoreCommentRepository {
  final CommentsNetworkDb firestoreComment;
  FireStoreCommentRepositoryImpl({required this.firestoreComment});
  final firestorePost = FireStorePostNetworkDbImpl();

  @override
  Future<Comment> addComment({required Comment commentInfo}) async {
    try {
      String commentId =
          await firestoreComment.addComment(commentInfo: commentInfo);

      Comment theCommentInfo =
          await firestoreComment.getCommentInfo(commentId: commentId);

      await firestorePost.putCommentOnThisPost(
          postId: theCommentInfo.postId, commentId: theCommentInfo.commentUid);
      return theCommentInfo;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> putLikeOnThisComment(
      {required String commentId, required String myPersonalId}) async {
    try {
      return await firestoreComment.putLikeOnThisComment(
          myPersonalId: myPersonalId, commentId: commentId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> removeLikeOnThisComment(
      {required String commentId, required String myPersonalId}) async {
    try {
      return await firestoreComment.removeLikeOnThisComment(
          myPersonalId: myPersonalId, commentId: commentId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<Comment>> getSpecificComments({required String postId}) async {
    try {
      List<dynamic> commentsIds =
          await firestorePost.getCommentsOfPost(postId: postId);
      List<Comment> theComments =
          await firestoreComment.getSpecificComments(commentsIds: commentsIds);

      return theComments;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
