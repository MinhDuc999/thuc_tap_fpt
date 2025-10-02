import 'package:login_todo/data/service/auth/auth_service.dart';

abstract class AuthRepository {
  Future<void> logIn(String email, String password);
  Future<void> logOut();
  Stream<bool> get userChanges;
}