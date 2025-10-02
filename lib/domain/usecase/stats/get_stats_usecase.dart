import 'package:login_todo/core/injection.dart';
import 'package:login_todo/domain/repositories/todos/todo_repository.dart';

class GetStatsUseCase {
  final _rep = getIt<TodoRepository>();

  Stream<(int, int)> execute() {
    return _rep.getTodos().map((todos) {
      final completed = todos.where((todo) => todo.isCompleted).length;
      final active = todos.where((todo) => !todo.isCompleted).length;
      return (completed, active);
    });
  }
}