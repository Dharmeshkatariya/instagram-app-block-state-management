import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_dharmesh_bloc_demo/features/auth/domain/repository/auth_repository.dart';
import '../../domain/entities/registered_user.dart';
import '../data_sources/remote/auth_network_db.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthNetworkDB authNetworkDB;
  AuthRepositoryImpl({required this.authNetworkDB});

  @override
  Future<User> logIn(RegisteredUser userInfo) async {
    try {
      return await authNetworkDB.logIn(
          email: userInfo.email, password: userInfo.password);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> signOut({required String userId}) async {
    try {
      await authNetworkDB.signOut();
      // await FireStoreNotification.deleteDeviceToken(userId: userId);
      return;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<User> signUp(RegisteredUser newUserInfo) async {
    try {
      User userId = await authNetworkDB.signUp(
          email: newUserInfo.email, password: newUserInfo.password);
      return userId;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<bool> isThisEmailToken({required String email}) async {
    try {
      bool isThisEmailToken =
          await authNetworkDB.isThisEmailToken(email: email);
      return isThisEmailToken;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
