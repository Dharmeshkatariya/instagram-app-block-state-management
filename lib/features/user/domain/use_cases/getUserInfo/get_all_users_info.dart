import '../../../../../core/usecase/usecase.dart';
import '../../../../../models/user_personal_info.dart';
import '../../repository/user_repository.dart';

class GetAllUsersUseCase
    implements StreamUseCase<List<UserPersonalInfo>, void> {
  final FireStoreUserRepository _getAllUsersUseCase;

  GetAllUsersUseCase(this._getAllUsersUseCase);

  @override
  Stream<List<UserPersonalInfo>> call({required void params}) {
    return _getAllUsersUseCase.getAllUsers();
  }
}
