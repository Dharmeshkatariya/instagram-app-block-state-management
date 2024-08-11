import '../../../../../../../core/usecase/usecase.dart';
import '../../../../repository/firestore_reply_repository.dart';

class RemoveLikeOnThisReplyUseCase
    implements UseCaseTwoParams<void, String, String> {
  final FireStoreReplyRepository _removeLikeOnThisReplyRepository;

  RemoveLikeOnThisReplyUseCase(this._removeLikeOnThisReplyRepository);

  @override
  Future<void> call(
      {required String paramsOne, required String paramsTwo}) async {
    return await _removeLikeOnThisReplyRepository.removeLikeOnThisReply(
        replyId: paramsOne, myPersonalId: paramsTwo);
  }
}
