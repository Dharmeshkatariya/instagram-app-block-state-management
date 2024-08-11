import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:instagram_dharmesh_bloc_demo/features/comments/data/data_sources/remote/firestore_comments/comments_network_db.dart';
import 'package:instagram_dharmesh_bloc_demo/models/comment.dart';

import '../../../../../../core/utils/strings_manager.dart';
import '../../../../../../models/user_personal_info.dart';
import '../../../../../user/data/data_sources/remote/firestore_user_network_db_impl.dart';

class CommentsNetworkDbImpl implements CommentsNetworkDb {
  FireStoreUserNetworkDbImpl fireStoreUserNetworkDbImpl =
      FireStoreUserNetworkDbImpl();

  static final _fireStoreCommentCollection =
      FirebaseFirestore.instance.collection('comments');

  @override
  Future<String> addComment({required Comment commentInfo}) async {
    DocumentReference<Map<String, dynamic>> commentRef =
        await _fireStoreCommentCollection.add(commentInfo.toMapComment());

    await _fireStoreCommentCollection
        .doc(commentRef.id)
        .update({'commentUid': commentRef.id});
    return commentRef.id;
  }

  @override
  Future<Comment> getCommentInfo({required String commentId}) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _fireStoreCommentCollection.doc(commentId).get();
    if (snap.exists) {
      Comment theCommentInfo = Comment.fromSnapComment(snap);
      UserPersonalInfo commentatorInfo = await fireStoreUserNetworkDbImpl
          .getUserInfo(theCommentInfo.whoCommentId);
      theCommentInfo.whoCommentInfo = commentatorInfo;

      return theCommentInfo;
    } else {
      return Future.error(StringsManager.userNotExist.tr);
    }
  }

  @override
  Future<List?> getRepliesOfComments({required String commentId}) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _fireStoreCommentCollection.doc(commentId).get();
    if (snap.exists) {
      Comment commentReformat = Comment.fromSnapComment(snap);

      return commentReformat.replies;
    } else {
      return Future.error(StringsManager.userNotExist.tr);
    }
  }

  @override
  Future<List<Comment>> getSpecificComments({required List commentsIds}) async {
    List<Comment> allComments = [];
    for (int i = 0; i < commentsIds.length; i++) {
      DocumentSnapshot<Map<String, dynamic>> snap =
          await _fireStoreCommentCollection.doc(commentsIds[i]).get();
      Comment commentReformat = Comment.fromSnapComment(snap);

      UserPersonalInfo commentatorInfo = await fireStoreUserNetworkDbImpl
          .getUserInfo(commentReformat.whoCommentId);
      commentReformat.whoCommentInfo = commentatorInfo;

      allComments.add(commentReformat);
    }
    return allComments;
  }

  @override
  Future<void> putLikeOnThisComment(
      {required String commentId, required String myPersonalId}) async {
    await _fireStoreCommentCollection.doc(commentId).update({
      'likes': FieldValue.arrayUnion([myPersonalId])
    });
  }

  @override
  Future<void> putReplyOnThisComment(
      {required String commentId, required String replyId}) async {
    await _fireStoreCommentCollection.doc(commentId).update({
      'replies': FieldValue.arrayUnion([replyId])
    });
  }

  @override
  Future<void> removeLikeOnThisComment(
      {required String commentId, required String myPersonalId}) async {
    await _fireStoreCommentCollection.doc(commentId).update({
      'likes': FieldValue.arrayRemove([myPersonalId])
    });
  }
}
