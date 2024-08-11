import '../../../../../core/usecase/usecase.dart';
import '../../../../../models/user_personal_info.dart';
import '../../repository/user_repository.dart';

class GetUserInfoUseCase
    implements UseCaseTwoParams<UserPersonalInfo, String, bool> {
  final FireStoreUserRepository _addNewUserRepository;

  GetUserInfoUseCase(this._addNewUserRepository);

  @override
  Future<UserPersonalInfo> call(
      {required String paramsOne, required bool paramsTwo}) {
    return _addNewUserRepository.getPersonalInfo(
        userId: paramsOne, getDeviceToken: paramsTwo);
  }
}
