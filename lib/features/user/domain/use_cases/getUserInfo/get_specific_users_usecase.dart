import '../../../../../core/usecase/usecase.dart';
import '../../../../../models/user_personal_info.dart';
import '../../entities/specific_user.dart';
import '../../repository/user_repository.dart';

class GetSpecificUsersUseCase
    implements UseCase<List<UserPersonalInfo>, List<dynamic>> {
  final FireStoreUserRepository _fireStoreUserRepository;

  GetSpecificUsersUseCase(this._fireStoreUserRepository);

  @override
  Future<List<UserPersonalInfo>> call({required List<dynamic> params}) {
    return _fireStoreUserRepository.getSpecificUsersInfo(usersIds: params);
  }
}
