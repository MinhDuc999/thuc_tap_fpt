import 'package:login_todo/core/injection.dart';
import 'package:login_todo/domain/repositories/todos/todo_repository.dart';
import 'package:login_todo/models/todos/todo_model.dart';

class DeleteTodoUseCase {
  final _rep = getIt<TodoRepository>();

  Future<(List<TodoModel>, TodoModel)> execute(int id, List<TodoModel> current) async {
    try {
      final todoToDelete = current.firstWhere((t) => t.id == id);
      final todos = await _rep.deleteTodo(id, current);
      return (todos, todoToDelete);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}