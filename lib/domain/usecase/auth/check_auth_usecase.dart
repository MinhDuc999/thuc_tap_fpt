import 'package:login_todo/core/injection.dart';
import 'package:login_todo/domain/repositories/auth/auth_repository.dart';

class CheckAuthUseCase {
  final _rep = getIt<AuthRepository>();

  Future<bool> execute() async {
    try {
      final user = await _rep.userChanges.first;
      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}