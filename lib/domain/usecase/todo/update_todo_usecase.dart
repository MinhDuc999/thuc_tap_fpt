import 'package:login_todo/core/injection.dart';
import 'package:login_todo/domain/repositories/todos/todo_repository.dart';
import 'package:login_todo/models/todos/todo_model.dart';

class UpdateTodoUseCase {
  final rep = getIt<TodoRepository>();

  Future<List<TodoModel>> execute(
      TodoModel updatedTodo, List<TodoModel> current) async {
    try {
      final todos = await rep.updateTodo(updatedTodo, current);
      return todos;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}