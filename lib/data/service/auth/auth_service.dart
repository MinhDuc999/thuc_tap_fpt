import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_todo/core/injection.dart';

class AuthService {
  //final FirebaseAuth _firebaseAuth;
  final _firebaseAuth = getIt<FirebaseAuth>();

  Future<void> logIn(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  Stream<bool> get userChanges => _firebaseAuth.authStateChanges().map((u) => u != null);
}