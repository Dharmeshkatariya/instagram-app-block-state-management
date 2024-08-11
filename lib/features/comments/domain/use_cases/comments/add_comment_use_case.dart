import '../../../../../../core/usecase/usecase.dart';
import '../../../../../../models/comment.dart';
import '../../repository/firestore_comments_repository.dart';

class AddCommentUseCase implements UseCase<Comment, Comment> {
  final FireStoreCommentRepository _addCommentRepository;

  AddCommentUseCase(this._addCommentRepository);

  @override
  Future<Comment> call({required Comment params}) {
    return _addCommentRepository.addComment(commentInfo: params);
  }
}
