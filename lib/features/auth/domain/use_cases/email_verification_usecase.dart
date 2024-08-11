import '../../../../core/usecase/usecase.dart';
import '../repository/auth_repository.dart';

class EmailVerificationUseCase implements UseCase<bool, String> {
  final AuthRepository _firebaseAuthRepository;

  EmailVerificationUseCase(this._firebaseAuthRepository);

  @override
  Future<bool> call({required String params}) {
    return _firebaseAuthRepository.isThisEmailToken(email: params);
  }
}
