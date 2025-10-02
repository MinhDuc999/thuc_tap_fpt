import 'package:login_todo/core/injection.dart';
import 'package:login_todo/domain/repositories/auth/auth_repository.dart';

class LogInUseCase {
  final _rep = getIt<AuthRepository>();

  Future<void> execute(String email, String password) async {

    try {
      await _rep.logIn(email, password);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}