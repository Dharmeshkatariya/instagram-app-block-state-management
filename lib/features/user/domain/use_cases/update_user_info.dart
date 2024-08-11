import '../../../../core/usecase/usecase.dart';
import '../../../../models/user_personal_info.dart';
import '../repository/user_repository.dart';

class UpdateUserInfoUseCase
    implements UseCase<UserPersonalInfo, UserPersonalInfo> {
  final FireStoreUserRepository _addNewUserRepository;

  UpdateUserInfoUseCase(this._addNewUserRepository);

  @override
  Future<UserPersonalInfo> call({required UserPersonalInfo params}) {
    return _addNewUserRepository.updateUserInfo(userInfo: params);
  }
}
