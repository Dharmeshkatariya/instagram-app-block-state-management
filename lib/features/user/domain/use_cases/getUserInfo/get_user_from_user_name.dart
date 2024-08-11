import '../../../../../core/usecase/usecase.dart';
import '../../../../../models/user_personal_info.dart';
import '../../repository/user_repository.dart';

class GetUserFromUserNameUseCase implements UseCase<UserPersonalInfo?, String> {
  final FireStoreUserRepository _getUserFromUserNameRepository;

  GetUserFromUserNameUseCase(this._getUserFromUserNameRepository);

  @override
  Future<UserPersonalInfo?> call({required String params}) {
    return _getUserFromUserNameRepository.getUserFromUserName(userName: params);
  }
}
