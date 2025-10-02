import 'package:equatable/equatable.dart';
import '../../models/enums/todo_type.dart';
import '../../models/todos/todo_model.dart';

enum TodoStatus { initial, loading, success, failure }

class TodoState extends Equatable {
  final TodoStatus status;
  final List<TodoModel> todos;
  final TodosViewFilter filter;
  final TodoModel? lastDeletedTodo;
  final String? errorMessage;

  const TodoState({
    this.status = TodoStatus.initial,
    this.todos = const [],
    this.filter = TodosViewFilter.all,
    this.lastDeletedTodo,
    this.errorMessage,
  });

  Iterable<TodoModel> get filteredTodos => filter.applyAll(todos);

  TodoState copyWith({
    TodoStatus? status,
    List<TodoModel>? todos,
    TodosViewFilter? filter,
    TodoModel? lastDeletedTodo,
    String? errorMessage,
  }) {
    return TodoState(
      status: status ?? this.status,
      todos: todos ?? this.todos,
      filter: filter ?? this.filter,
      lastDeletedTodo: lastDeletedTodo ?? this.lastDeletedTodo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, todos, filter, lastDeletedTodo, errorMessage];
}
