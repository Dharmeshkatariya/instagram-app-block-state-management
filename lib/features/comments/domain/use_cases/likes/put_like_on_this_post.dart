import '../../../../../../core/usecase/usecase.dart';
import '../../../../../../models/comment.dart';
import '../../../../../models/post/post.dart';
import '../../repository/firestore_comments_repository.dart';
import '../../repository/firestore_post_repository.dart';

class PutLikeOnThisPostUseCase
    implements UseCaseTwoParams<void, String, String> {
  final FireStorePostRepository _putLikeOnThisPostRepository;

  PutLikeOnThisPostUseCase(this._putLikeOnThisPostRepository);

  @override
  Future<void> call({required String paramsOne, required String paramsTwo}) {
    return _putLikeOnThisPostRepository.putLikeOnThisPost(
        postId: paramsOne, userId: paramsTwo);
  }
}
