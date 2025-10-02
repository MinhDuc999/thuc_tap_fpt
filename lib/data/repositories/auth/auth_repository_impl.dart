import 'package:login_todo/core/injection.dart';
import 'package:login_todo/domain/repositories/auth/auth_repository.dart';
import 'package:login_todo/data/service/auth/auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final _service = getIt<AuthService>();


  @override
  Future<void> logIn(String email, String password) async {
    await _service.logIn(email, password);
  }

  @override
  Future<void> logOut() async {
    await _service.logOut();
  }

  @override
  Stream<bool> get userChanges => _service.userChanges;
}