import '../../../../../../core/usecase/usecase.dart';
import '../../../../../../models/comment.dart';
import '../../../../../models/post/post.dart';
import '../../repository/firestore_comments_repository.dart';
import '../../repository/firestore_post_repository.dart';

class RemoveTheLikeOnThisPostUseCase
    implements UseCaseTwoParams<void, String, String> {
  final FireStorePostRepository _removeTheLikeOnThisPostRepository;

  RemoveTheLikeOnThisPostUseCase(this._removeTheLikeOnThisPostRepository);

  @override
  Future<void> call({required String paramsOne, required String paramsTwo}) {
    return _removeTheLikeOnThisPostRepository.removeTheLikeOnThisPost(
        postId: paramsOne, userId: paramsTwo);
  }
}
