import '../../../../../../core/usecase/usecase.dart';
import '../../../../../../models/comment.dart';
import '../../repository/firestore_comments_repository.dart';

class RemoveLikeOnThisCommentUseCase
    implements UseCaseTwoParams<void, String, String> {
  final FireStoreCommentRepository _removeLikeRepository;

  RemoveLikeOnThisCommentUseCase(this._removeLikeRepository);

  @override
  Future<void> call({required String paramsOne, required String paramsTwo}) {
    return _removeLikeRepository.removeLikeOnThisComment(
        commentId: paramsOne, myPersonalId: paramsTwo);
  }
}
