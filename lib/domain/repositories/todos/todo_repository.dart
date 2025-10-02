import 'package:login_todo/models/todos/todo_model.dart';

abstract class TodoRepository {
  Future<List<TodoModel>> loadTodos();
  Future<List<TodoModel>> addTodo(String title, String description, List<TodoModel> current);
  Future<List<TodoModel>> toggleTodo(int id, List<TodoModel> current);
  Future<List<TodoModel>> deleteTodo(int id, List<TodoModel> current);
  Future<List<TodoModel>> updateTodo(TodoModel updatedTodo, List<TodoModel> current);
  Future<List<TodoModel>> clearCompleted(List<TodoModel> current);
  Future<void> saveTodos(List<TodoModel> todos);
  Stream<List<TodoModel>> getTodos();
}