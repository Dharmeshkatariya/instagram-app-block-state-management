import '../../../../../../../core/usecase/usecase.dart';
import '../../../../repository/firestore_reply_repository.dart';

class PutLikeOnThisReplyUseCase
    implements UseCaseTwoParams<void, String, String> {
  final FireStoreReplyRepository _putLikeOnThisReplyRepository;

  PutLikeOnThisReplyUseCase(this._putLikeOnThisReplyRepository);

  @override
  Future<void> call(
      {required String paramsOne, required String paramsTwo}) async {
    return await _putLikeOnThisReplyRepository.putLikeOnThisReply(
        replyId: paramsOne, myPersonalId: paramsTwo);
  }
}
