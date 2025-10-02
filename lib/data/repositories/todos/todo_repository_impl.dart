import 'dart:async';
import 'package:login_todo/core/injection.dart';
import 'package:login_todo/models/todos/todo_model.dart';
import 'package:login_todo/domain/repositories/todos/todo_repository.dart';
import 'package:login_todo/data/service/todos/todo_service.dart';

class TodoRepositoryImpl implements TodoRepository {
  //final TodoService _service;
  final _service = getIt<TodoService>();

  TodoRepositoryImpl();

  @override
  Future<List<TodoModel>> loadTodos() async {
    return await _service.loadTodos();
  }

  @override
  Future<List<TodoModel>> addTodo(String title, String description, List<TodoModel> current) async {
    await _service.addTodos(title, description, current);
    return await _service.loadTodos();
  }

  @override
  Future<List<TodoModel>> toggleTodo(int id, List<TodoModel> current) async {
    await _service.toggleTodo(id, current);
    return await _service.loadTodos();
  }

  @override
  Future<List<TodoModel>> deleteTodo(int id, List<TodoModel> current) async {
    await _service.deleteTodo(id, current);
    return await _service.loadTodos();
  }

  @override
  Future<List<TodoModel>> updateTodo(TodoModel updatedTodo, List<TodoModel> current) async {
    await _service.updateTodo(updatedTodo, current);
    return await _service.loadTodos();
  }

  @override
  Future<List<TodoModel>> clearCompleted(List<TodoModel> current) async {
    await _service.clearCompleted(current);
    return await _service.loadTodos();
  }

  @override
  Future<void> saveTodos(List<TodoModel> todos) async {
    await _service.saveAll(todos);
  }

  @override
  Stream<List<TodoModel>> getTodos() => _service.getTodos();

}