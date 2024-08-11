import '../../../../../../models/post/post.dart';

abstract class FireStorePostNetworkDb {
  Future<Post> createPost(Post postInfo);
  Future<void> deletePost({required Post postInfo});
  Future<Post> updatePost({required Post postInfo});

  Future<List<Post>> getPostsInfo(
      {required List<dynamic> postsIds, required int lengthOfCurrentList});

  Future<List<dynamic>> getCommentsOfPost({required String postId});

  Future<List<Post>> getAllPostsInfo(
      {required bool isVideosWantedOnly, required String skippedVideoUid});

  Future putLikeOnThisPost({required String postId, required String userId});

  Future removeTheLikeOnThisPost(
      {required String postId, required String userId});

  putCommentOnThisPost({required String postId, required String commentId});

  removeTheCommentOnThisPost(
      {required String postId, required String commentId});
}
