import 'package:firebase_auth/firebase_auth.dart';
import '../entities/registered_user.dart';

abstract class AuthRepository {
  Future<User> signUp(RegisteredUser newUserInfo);
  Future<User> logIn(RegisteredUser userInfo);
  Future<void> signOut({required String userId});
  Future<bool> isThisEmailToken({required String email});
}
