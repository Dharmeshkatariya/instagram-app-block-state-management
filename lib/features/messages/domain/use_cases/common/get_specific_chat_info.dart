import '../../../../../core/usecase/usecase.dart';
import '../../../../user/domain/entities/sender_info.dart';
import '../../../../user/domain/repository/user_repository.dart';

class GetSpecificChatInfo
    implements UseCaseTwoParams<SenderInfo, String, bool> {
  final FireStoreUserRepository _getSpecificChatInfoRepository;

  GetSpecificChatInfo(this._getSpecificChatInfoRepository);

  @override
  Future<SenderInfo> call(
      {required String paramsOne, required bool paramsTwo}) {
    return _getSpecificChatInfoRepository.getSpecificChatInfo(
        chatUid: paramsOne, isThatGroup: paramsTwo);
  }
}
