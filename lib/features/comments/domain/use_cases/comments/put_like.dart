import '../../../../../../core/usecase/usecase.dart';
import '../../../../../../models/comment.dart';
import '../../repository/firestore_comments_repository.dart';

class PutLikeOnThisCommentUseCase
    implements UseCaseTwoParams<void, String, String> {
  final FireStoreCommentRepository _putLikeRepository;

  PutLikeOnThisCommentUseCase(this._putLikeRepository);

  @override
  Future<void> call({required String paramsOne, required String paramsTwo}) {
    return _putLikeRepository.putLikeOnThisComment(
        commentId: paramsOne, myPersonalId: paramsTwo);
  }
}
