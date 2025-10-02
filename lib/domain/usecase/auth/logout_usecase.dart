import 'package:login_todo/core/injection.dart';
import 'package:login_todo/domain/repositories/auth/auth_repository.dart';

class LogOutUseCase {
  final _rep = getIt<AuthRepository>();

  Future<void> execute() async {
    try {
      await _rep.logOut();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
