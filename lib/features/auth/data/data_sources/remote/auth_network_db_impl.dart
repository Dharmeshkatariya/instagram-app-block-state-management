import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_dharmesh_bloc_demo/features/auth/data/data_sources/remote/auth_network_db.dart';

class AuthNetworkDbImpl extends AuthNetworkDB {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  get user => _firebaseAuth.currentUser;

  @override
  Future<bool> isThisEmailToken({required String email}) async {
    List<String> data = await _firebaseAuth.fetchSignInMethodsForEmail(email);

    return data.isNotEmpty;
  }

  @override
  Future<User> logIn({required String email, required String password}) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    final user = result.user!;
    return user;
  }

  @override
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  @override
  Future<User> signUp({required String email, required String password}) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    final user = result.user!;
    return user;
  }
}
