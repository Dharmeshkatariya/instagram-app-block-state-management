import '../../../../core/usecase/usecase.dart';
import '../../../../models/user_personal_info.dart';
import '../repository/user_repository.dart';

class AddNewUserUseCase implements UseCase<void, UserPersonalInfo> {
  final FireStoreUserRepository _addNewUserRepository;

  AddNewUserUseCase(this._addNewUserRepository);

  @override
  Future<void> call({required UserPersonalInfo params}) {
    return _addNewUserRepository.addNewUser(params);
  }
}
