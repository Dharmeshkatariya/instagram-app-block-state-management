import '../../../../../core/usecase/usecase.dart';
import '../../../../../models/message.dart';
import '../../repository/group_message.dart';

class GetMessagesGroGroupChatUseCase
    implements StreamUseCase<List<Message>, String> {
  final FireStoreGroupMessageRepository _addPostToUserRepository;

  GetMessagesGroGroupChatUseCase(this._addPostToUserRepository);

  @override
  Stream<List<Message>> call({required String params}) {
    return _addPostToUserRepository.getMessages(groupChatUid: params);
  }
}
