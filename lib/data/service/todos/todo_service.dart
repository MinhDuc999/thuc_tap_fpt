import 'dart:async';
import 'dart:convert';
import 'package:login_todo/core/injection.dart';
import 'package:login_todo/models/todos/todo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoService {
  static const _kTodosKey = 'todos_list_v1';
  //final SharedPreferences _prefs;
  final _prefs = getIt<SharedPreferences>();
  int _currentId = 0;
  final _controller = StreamController<List<TodoModel>>.broadcast();

  Future<List<TodoModel>> loadTodos() async {
    final raw = _prefs.getString(_kTodosKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = json.decode(raw) as List<dynamic>;
      final todos = list.map((e) => TodoModel.fromJson(e as Map<String, dynamic>)).toList();
      if (todos.isNotEmpty) {
        _currentId = todos.map((t) => t.id).reduce((a, b) => a > b ? a : b);
      }
      return todos;
    } catch (_) {
      return [];
    }
  }

  Future<void> addTodos(String title, String description, List<TodoModel> current) async {
    _currentId++;
    final todo = TodoModel.create(_currentId, title, description);
    final newList = List<TodoModel>.from(current)..insert(0, todo);
    await saveAll(newList);
  }

  Future<void> toggleTodo(int id, List<TodoModel> current) async {
    final newList = current.map((t) => t.id == id ? t.copyWith(isCompleted: !t.isCompleted) : t).toList();
    await saveAll(newList);
  }

  Future<void> deleteTodo(int id, List<TodoModel> current) async {
    final newList = current.where((t) => t.id != id).toList();
    await saveAll(newList);
  }

  Future<void> updateTodo(TodoModel updatedTodo, List<TodoModel> current) async {
    final newList = current.map((t) => t.id == updatedTodo.id ? updatedTodo : t).toList();
    await saveAll(newList);
  }

  Future<void> clearCompleted(List<TodoModel> current) async {
    final newList = current.where((t) => !t.isCompleted).toList();
    await saveAll(newList);
  }

  Stream<List<TodoModel>> getTodos() {
    loadTodos().then((value) => _controller.add(value));
    return _controller.stream;
  }

  Future<void> saveAll(List<TodoModel> todos) async {
    final list = todos.map((t) => t.toJson()).toList();
    await _prefs.setString(_kTodosKey, json.encode(list));
    _controller.add(todos);
  }

}