import '../../../../core/usecase/usecase.dart';
import '../repository/auth_repository.dart';

class SignOutAuthUseCase implements UseCase<void, String> {
  final AuthRepository _firebaseAuthRepository;

  SignOutAuthUseCase(this._firebaseAuthRepository);

  @override
  Future<void> call({required String params}) {
    return _firebaseAuthRepository.signOut(userId: params);
  }
}
