import 'package:equatable/equatable.dart';
import 'package:login_todo/models/enums/todo_edit.dart';
import 'package:login_todo/models/todos/todo_model.dart';

class EditTodoState extends Equatable {
  final EditTodoStatus status;
  final TodoModel? initialTodo;

  const EditTodoState({
    this.status = EditTodoStatus.initial,
    this.initialTodo,
  });

  EditTodoState copyWith({
    EditTodoStatus? status,
    TodoModel? initialTodo,
  }) {
    return EditTodoState(
      status: status ?? this.status,
      initialTodo: initialTodo ?? this.initialTodo,
    );
  }

  @override
  List<Object?> get props => [status, initialTodo];
}