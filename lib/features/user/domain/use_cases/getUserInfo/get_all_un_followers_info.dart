import '../../../../../core/usecase/usecase.dart';
import '../../../../../models/user_personal_info.dart';
import '../../repository/user_repository.dart';

class GetAllUnFollowersUseCase
    implements UseCase<List<UserPersonalInfo>, UserPersonalInfo> {
  final FireStoreUserRepository _getAllUnFollowersUsersUseCase;

  GetAllUnFollowersUseCase(this._getAllUnFollowersUsersUseCase);

  @override
  Future<List<UserPersonalInfo>> call({required UserPersonalInfo params}) {
    return _getAllUnFollowersUsersUseCase.getAllUnFollowersUsers(params);
  }
}
