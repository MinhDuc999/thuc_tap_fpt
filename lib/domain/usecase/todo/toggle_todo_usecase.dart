import 'package:login_todo/core/injection.dart';
import 'package:login_todo/domain/repositories/todos/todo_repository.dart';
import 'package:login_todo/models/todos/todo_model.dart';

class ToggleTodoUseCase {
  final _rep = getIt<TodoRepository>();

  Future<List<TodoModel>> execute(int id, List<TodoModel> current) async {
    try {
      final todos = await _rep.toggleTodo(id, current);
      return todos;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}