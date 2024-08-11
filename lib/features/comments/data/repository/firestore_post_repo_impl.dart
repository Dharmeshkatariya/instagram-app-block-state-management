import 'dart:typed_data';
import '../../../../core/constants/constants.dart';
import '../../../../models/post/post.dart';
import '../../../auth/data/data_sources/remote/firebase_storage.dart';
import '../../../user/data/data_sources/remote/firestore_user_network_db_impl.dart';
import '../../domain/repository/firestore_post_repository.dart';
import '../data_sources/remote/firestore_post/firestore_post_network_db.dart';
import 'package:image_picker_plus/image_picker_plus.dart' as ipp;

class FireStorePostRepositoryImpl implements FireStorePostRepository {
  final FireStorePostNetworkDb firestorePost;
  FireStorePostRepositoryImpl({required this.firestorePost});
  final firestoreUser = FireStoreUserNetworkDbImpl();

  @override
  Future<Post> createPost({
    required Uint8List? coverOfVideo,
    required List<ipp.SelectedByte> files,
    required Post postInfo,
  }) async {
    try {
      bool isFirstPostImage = files[0].isThatImage;
      bool isThatMix = false;
      postInfo.isThatImage = isFirstPostImage;
      for (int i = 0; i < files.length; i++) {
        bool isThatImage = files[i].isThatImage;
        if (!isThatMix) isThatMix = !isThatImage == isFirstPostImage;

        String fileName = isThatImage ? "jpg" : "mp4";
        String postUrl;
        if (isThatMobile) {
          postUrl = await FirebaseStoragePost.uploadFile(
              postFile: files[i].selectedFile, folderName: fileName);
        } else {
          postUrl = await FirebaseStoragePost.uploadData(
              data: files[i].selectedByte, folderName: fileName);
        }

        if (i == 0) postInfo.postUrl = postUrl;
        postInfo.imagesUrls.add(postUrl);
      }
      if (coverOfVideo != null) {
        String coverOfVideoUrl = await FirebaseStoragePost.uploadData(
            data: coverOfVideo, folderName: 'postsVideo');
        postInfo.coverOfVideoUrl = coverOfVideoUrl;
      }

      postInfo.isThatMix = isThatMix;
      Post newPostInfo = await firestorePost.createPost(postInfo);
      return newPostInfo;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<Post>> getPostsInfo({
    required List<dynamic> postsIds,
    required int lengthOfCurrentList,
  }) async {
    try {
      return await firestorePost.getPostsInfo(
          postsIds: postsIds, lengthOfCurrentList: lengthOfCurrentList);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<Post>> getAllPostsInfo({
    required bool isVideosWantedOnly,
    required String skippedVideoUid,
  }) async {
    try {
      return await firestorePost.getAllPostsInfo(
          isVideosWantedOnly: isVideosWantedOnly,
          skippedVideoUid: skippedVideoUid);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List> getSpecificUsersPosts(List<dynamic> usersIds) async {
    try {
      return await firestoreUser.getSpecificUsersPosts(usersIds);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> putLikeOnThisPost({
    required String postId,
    required String userId,
  }) async {
    try {
      return await firestorePost.putLikeOnThisPost(
          postId: postId, userId: userId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> removeTheLikeOnThisPost({
    required String postId,
    required String userId,
  }) async {
    try {
      return await firestorePost.removeTheLikeOnThisPost(
          postId: postId, userId: userId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> deletePost({required Post postInfo}) async {
    try {
      await firestorePost.deletePost(postInfo: postInfo);
      await FirebaseStoragePost.deleteImageFromStorage(postInfo.postUrl);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<Post> updatePost({required Post postInfo}) async {
    try {
      return await firestorePost.updatePost(postInfo: postInfo);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
