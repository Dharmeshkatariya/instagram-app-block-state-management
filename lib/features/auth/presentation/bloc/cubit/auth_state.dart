part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class CubitInitial extends AuthState {}

class CubitAuthConfirming extends AuthState {}

class CubitAuthConfirmed extends AuthState {
  final User user;

  CubitAuthConfirmed(this.user);
}

class CubitEmailVerificationLoaded extends AuthState {
  final bool isThisEmailToken;

  CubitEmailVerificationLoaded(this.isThisEmailToken);
}

class CubitEmailVerificationLoading extends AuthState {
  CubitEmailVerificationLoading();
}

class CubitAuthSignOut extends AuthState {}

class CubitAuthFailed extends AuthState {
  final String error;
  CubitAuthFailed(this.error);
}
