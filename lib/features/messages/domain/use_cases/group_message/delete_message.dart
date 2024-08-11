import '../../../../../core/usecase/usecase.dart';
import '../../../../../models/message.dart';
import '../../repository/group_message.dart';

class DeleteMessageForGroupChatUseCase
    implements UseCaseThreeParams<void, String, Message, Message?> {
  final FireStoreGroupMessageRepository _addPostToUserRepository;

  DeleteMessageForGroupChatUseCase(this._addPostToUserRepository);

  @override
  Future<void> call({
    required String paramsOne,
    required Message paramsTwo,
    required Message? paramsThree,
  }) {
    return _addPostToUserRepository.deleteMessage(
        chatOfGroupUid: paramsOne,
        messageInfo: paramsTwo,
        replacedMessage: paramsThree);
  }
}
