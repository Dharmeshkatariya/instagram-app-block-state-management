import '../../../../../core/usecase/usecase.dart';
import '../../../../../models/message.dart';
import '../../../../user/domain/repository/user_repository.dart';

class DeleteMessageUseCase
    implements UseCaseThreeParams<void, Message, Message?, bool> {
  final FireStoreUserRepository _addPostToUserRepository;

  DeleteMessageUseCase(this._addPostToUserRepository);

  @override
  Future<void> call(
      {required Message paramsOne,
      required Message? paramsTwo,
      required bool paramsThree}) {
    return _addPostToUserRepository.deleteMessage(
        messageInfo: paramsOne,
        replacedMessage: paramsTwo,
        isThatOnlyMessageInChat: paramsThree);
  }
}
