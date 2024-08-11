import "package:firebase_auth/firebase_auth.dart";

abstract class AuthNetworkDB {
  Future<User> signUp({required String email, required String password});

  Future<User> logIn({required String email, required String password});

  Future<bool> isThisEmailToken({required String email});

  Future<void> signOut();
}
