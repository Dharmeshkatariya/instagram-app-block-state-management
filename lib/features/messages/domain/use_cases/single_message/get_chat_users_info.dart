import '../../../../../core/usecase/usecase.dart';
import '../../../../../models/message.dart';
import '../../../../../models/user_personal_info.dart';
import '../../../../user/domain/entities/sender_info.dart';
import '../../../../user/domain/repository/user_repository.dart';

class GetChatUsersInfoAddMessageUseCase
    implements UseCase<List<SenderInfo>, UserPersonalInfo> {
  final FireStoreUserRepository _addPostToUserRepository;

  GetChatUsersInfoAddMessageUseCase(this._addPostToUserRepository);

  @override
  Future<List<SenderInfo>> call({required UserPersonalInfo params}) {
    return _addPostToUserRepository.getChatUserInfo(myPersonalInfo: params);
  }
}
