import '../../../../../core/usecase/usecase.dart';
import '../../repository/user_repository.dart';

class FollowThisUserUseCase implements UseCaseTwoParams<void, String, String> {
  final FireStoreUserRepository _addNewUserRepository;

  FollowThisUserUseCase(this._addNewUserRepository);

  @override
  Future<void> call({required String paramsOne, required String paramsTwo}) {
    return _addNewUserRepository.followThisUser(paramsOne, paramsTwo);
  }
}
