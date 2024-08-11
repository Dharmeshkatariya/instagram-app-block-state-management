import '../../../../../../core/usecase/usecase.dart';
import '../../../../../../models/comment.dart';
import '../../../repository/firestore_reply_repository.dart';

class ReplyOnThisCommentUseCase implements UseCase<Comment, Comment> {
  final FireStoreReplyRepository _replayOnThisCommentRepository;

  ReplyOnThisCommentUseCase(this._replayOnThisCommentRepository);

  @override
  Future<Comment> call({required Comment params}) async {
    return await _replayOnThisCommentRepository.replyOnThisComment(
        replyInfo: params);
  }
}
