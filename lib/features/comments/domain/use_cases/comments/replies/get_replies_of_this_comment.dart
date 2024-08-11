import '../../../../../../core/usecase/usecase.dart';
import '../../../../../../models/comment.dart';
import '../../../repository/firestore_reply_repository.dart';

class GetRepliesOfThisCommentUseCase implements UseCase<List<Comment>, String> {
  final FireStoreReplyRepository _getRepliesOfThisCommentRepository;

  GetRepliesOfThisCommentUseCase(this._getRepliesOfThisCommentRepository);

  @override
  Future<List<Comment>> call({required String params}) async {
    return await _getRepliesOfThisCommentRepository.getSpecificReplies(
      commentId: params,
    );
  }
}
