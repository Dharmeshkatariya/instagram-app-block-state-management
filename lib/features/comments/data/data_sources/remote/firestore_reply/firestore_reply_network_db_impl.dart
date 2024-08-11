import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:instagram_dharmesh_bloc_demo/features/comments/data/data_sources/remote/firestore_reply/firestore_reply_network_db.dart';
import 'package:instagram_dharmesh_bloc_demo/models/comment.dart';

import '../../../../../../core/utils/strings_manager.dart';
import '../../../../../../models/user_personal_info.dart';
import '../../../../../user/data/data_sources/remote/firestore_user_network_db_impl.dart';

class FireStoreReplyNetworkDbImpl implements FireStoreReplyNetworkDb {
  static final _fireStoreReplyCollection =
      FirebaseFirestore.instance.collection('replies');

  final firestoreUser = FireStoreUserNetworkDbImpl();

  @override
  Future<Comment> getReplyInfo({required String replyId}) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _fireStoreReplyCollection.doc(replyId).get();
    if (snap.exists) {
      return Comment.fromSnapReply(snap);
    } else {
      return Future.error(StringsManager.userNotExist.tr);
    }
  }

  @override
  Future<List<Comment>> getSpecificReplies({required List repliesIds}) async {
    List<Comment> allReplies = [];

    for (int i = 0; i < repliesIds.length; i++) {
      DocumentSnapshot<Map<String, dynamic>> snap =
          await _fireStoreReplyCollection.doc(repliesIds[i]).get();
      Comment replyReformat = Comment.fromSnapReply(snap);

      UserPersonalInfo whoReplyInfo =
          await firestoreUser.getUserInfo(replyReformat.whoCommentId);
      replyReformat.whoCommentInfo = whoReplyInfo;

      allReplies.add(replyReformat);
    }
    return allReplies;
  }

  @override
  Future<void> putLikeOnThisReply(
      {required String replyId, required String myPersonalId}) async {
    await _fireStoreReplyCollection.doc(replyId).update({
      'likes': FieldValue.arrayUnion([myPersonalId])
    });
  }

  @override
  Future<void> removeLikeOnThisReply(
      {required String replyId, required String myPersonalId}) async {
    await _fireStoreReplyCollection.doc(replyId).update({
      'likes': FieldValue.arrayRemove([myPersonalId])
    });
  }

  @override
  Future<String> replyOnThisComment({required Comment replyInfo}) async {
    DocumentReference<Map<String, dynamic>> commentRef =
        await _fireStoreReplyCollection.add(replyInfo.toMapReply());

    await _fireStoreReplyCollection
        .doc(commentRef.id)
        .update({'replyUid': commentRef.id});
    return commentRef.id;
  }
}
