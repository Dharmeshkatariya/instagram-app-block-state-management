import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import '../../../../../export.dart';
import '../../../../../injection_container.dart';
import '../../../domain/entities/registered_user.dart';
import '../../../domain/use_cases/email_verification_usecase.dart';
import '../../../domain/use_cases/log_in_auth_usecase.dart';
import '../../../domain/use_cases/sign_out_auth_usecase.dart';
import '../../../domain/use_cases/sign_up_auth_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(CubitInitial());
  User? user;

  static AuthCubit get(BuildContext context) => BlocProvider.of(context);

  Future<User?> signUp(RegisteredUser newUserInfo) async {
    emit(CubitAuthConfirming());
    await locator
        .call<SignUpAuthUseCase>()
        .call(params: newUserInfo)
        .then((newUser) {
      emit(CubitAuthConfirmed(newUser));
      user = newUser;
    }).catchError((e) {
      emit(CubitAuthFailed(e.toString()));
    });
    return user;
  }

  Future<void> logIn(RegisteredUser userInfo) async {
    emit(CubitAuthConfirming());
    await locator.call<LogInAuthUseCase>()(params: userInfo).then((user) {
      emit(CubitAuthConfirmed(user));
      this.user = user;
    }).catchError((e) {
      emit(CubitAuthFailed(e.toString()));
    });
  }

  Future<void> signOut({required String userId}) async {
    emit(CubitAuthConfirming());
    await locator
        .call<SignOutAuthUseCase>()
        .call(params: userId)
        .then((value) async {
      emit(CubitAuthSignOut());
    }).catchError((e) {
      emit(CubitAuthFailed(e.toString()));
    });
  }

  Future<void> isThisEmailToken({required String email}) async {
    if (email.isEmpty) return;

    emit(CubitEmailVerificationLoading());
    await locator
        .call<EmailVerificationUseCase>()
        .call(params: email)
        .then((value) async {
      emit(CubitEmailVerificationLoaded(value));
    }).catchError((e) {
      emit(CubitAuthFailed(e.toString()));
    });
  }
}
