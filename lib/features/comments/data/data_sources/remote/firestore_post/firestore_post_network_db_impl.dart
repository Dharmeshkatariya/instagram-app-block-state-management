import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../../../core/utils/strings_manager.dart';
import '../../../../../../models/post/post.dart';
import '../../../../../../models/user_personal_info.dart';
import '../../../../../user/data/data_sources/remote/firestore_user_network_db_impl.dart';
import 'firestore_post_network_db.dart';

class FireStorePostNetworkDbImpl implements FireStorePostNetworkDb {
  static final _fireStorePostCollection =
      FirebaseFirestore.instance.collection('posts');
  final firestoreUser = FireStoreUserNetworkDbImpl();

  @override
  Future<Post> createPost(Post postInfo) async {
    DocumentReference<Map<String, dynamic>> postRef =
        await _fireStorePostCollection.add(postInfo.toMap());

    await _fireStorePostCollection
        .doc(postRef.id)
        .update({"postUid": postRef.id});
    postInfo.postUid = postRef.id;
    return postInfo;
  }

  @override
  Future<void> deletePost({required Post postInfo}) async {
    await _fireStorePostCollection.doc(postInfo.postUid).delete();
    await firestoreUser.removeUserPost(postId: postInfo.postUid);
  }

  @override
  Future<List<Post>> getAllPostsInfo(
      {required bool isVideosWantedOnly,
      required String skippedVideoUid}) async {
    List<Post> allPosts = [];
    QuerySnapshot<Map<String, dynamic>> snap;
    if (isVideosWantedOnly) {
      snap = await _fireStorePostCollection
          .where("isThatImage", isEqualTo: false)
          .get();
    } else {
      snap = await _fireStorePostCollection.get();
    }
    for (final doc in snap.docs) {
      if (skippedVideoUid == doc.id) continue;
      Post postReformat = Post.fromQuery(query: doc);
      UserPersonalInfo publisherInfo =
          await firestoreUser.getUserInfo(postReformat.publisherId);
      postReformat.publisherInfo = publisherInfo;

      allPosts.add(postReformat);
    }
    return allPosts;
  }

  @override
  Future<List> getCommentsOfPost({required String postId}) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _fireStorePostCollection.doc(postId).get();
    if (snap.exists) {
      Post postReformat = Post.fromQuery(doc: snap);
      return postReformat.comments;
    } else {
      return Future.error(StringsManager.userNotExist.tr);
    }
  }

  @override
  Future<List<Post>> getPostsInfo(
      {required List postsIds, required int lengthOfCurrentList}) async {
    List<Post> postsInfo = [];
    int condition = postsIds.length;
    if (lengthOfCurrentList != -1) {
      int lengthOfOriginPost = postsIds.length;
      int lengthOfData = lengthOfOriginPost > 5 ? 5 : lengthOfOriginPost;
      int addMoreData = lengthOfCurrentList + 5;
      lengthOfData =
          addMoreData < lengthOfOriginPost ? addMoreData : lengthOfOriginPost;
      condition = lengthOfData;
    }
    for (int i = 0; i < condition; i++) {
      try {
        DocumentSnapshot<Map<String, dynamic>> snap =
            await _fireStorePostCollection.doc(postsIds[i]).get();
        if (snap.exists) {
          Post postReformat = Post.fromQuery(doc: snap);
          if (postReformat.postUrl.isNotEmpty) {
            UserPersonalInfo publisherInfo =
                await firestoreUser.getUserInfo(postReformat.publisherId);
            postReformat.publisherInfo = publisherInfo;
            postsInfo.add(postReformat);
          } else {
            await deletePost(postInfo: postReformat);
          }
        } else {
          firestoreUser.removeUserPost(postId: postsIds[i]);
        }
      } catch (e) {
        continue;
      }
    }
    return postsInfo;
  }

  @override
  putCommentOnThisPost(
      {required String postId, required String commentId}) async {
    await _fireStorePostCollection.doc(postId).update({
      'comments': FieldValue.arrayUnion([commentId])
    });
  }

  @override
  Future putLikeOnThisPost(
      {required String postId, required String userId}) async {
    await _fireStorePostCollection.doc(postId).update({
      'likes': FieldValue.arrayUnion([userId])
    });
  }

  @override
  removeTheCommentOnThisPost(
      {required String postId, required String commentId}) async {
    await _fireStorePostCollection.doc(postId).update({
      'comments': FieldValue.arrayRemove([commentId])
    });
  }

  @override
  Future removeTheLikeOnThisPost(
      {required String postId, required String userId}) async {
    await _fireStorePostCollection.doc(postId).update({
      'likes': FieldValue.arrayRemove([userId])
    });
  }

  @override
  Future<Post> updatePost({required Post postInfo}) async {
    await _fireStorePostCollection
        .doc(postInfo.postUid)
        .update({'caption': postInfo.caption});
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _fireStorePostCollection.doc(postInfo.postUid).get();
    return Post.fromQuery(doc: snap);
  }
}
