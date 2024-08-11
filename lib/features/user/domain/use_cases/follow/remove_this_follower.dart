import '../../../../../core/usecase/usecase.dart';
import '../../repository/user_repository.dart';

class UnFollowThisUserUseCase
    implements UseCaseTwoParams<void, String, String> {
  final FireStoreUserRepository _unFollowThisUserRepository;

  UnFollowThisUserUseCase(this._unFollowThisUserRepository);

  @override
  Future<void> call({required String paramsOne, required String paramsTwo}) {
    return _unFollowThisUserRepository.unFollowThisUser(paramsOne, paramsTwo);
  }
}
