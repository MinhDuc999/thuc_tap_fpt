import 'package:login_todo/core/injection.dart';
import 'package:login_todo/domain/repositories/todos/todo_repository.dart';
import 'package:login_todo/models/todos/todo_model.dart';

class LoadTodosUseCase {
  final _rep = getIt<TodoRepository>();

  Future<List<TodoModel>> execute() async {
    try {
      return await _rep.loadTodos();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}