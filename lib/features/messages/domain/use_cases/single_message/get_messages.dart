import '../../../../../core/usecase/usecase.dart';
import '../../../../../models/message.dart';
import '../../../../user/domain/repository/user_repository.dart';

class GetMessagesUseCase implements StreamUseCase<List<Message>, String> {
  final FireStoreUserRepository _addPostToUserRepository;

  GetMessagesUseCase(this._addPostToUserRepository);

  @override
  Stream<List<Message>> call({required String params}) {
    return _addPostToUserRepository.getMessages(receiverId: params);
  }
}
