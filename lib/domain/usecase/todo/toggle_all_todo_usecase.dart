import 'package:login_todo/core/injection.dart';
import 'package:login_todo/domain/repositories/todos/todo_repository.dart';
import 'package:login_todo/models/todos/todo_model.dart';

class ToggleAllTodosUseCase {
  final _rep = getIt<TodoRepository>();

  Future<List<TodoModel>> execute(List<TodoModel> current) async {
    try {
      final allCompleted = current.every((t) => t.isCompleted);
      final newList = current.map((t) => t.copyWith(isCompleted: !allCompleted)).toList();
      await _rep.saveTodos(newList);
      return newList;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}