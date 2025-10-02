import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_todo/bloc/todo_edit/edit_todo_event.dart';
import 'package:login_todo/bloc/todo_edit/edit_todo_state.dart';
import 'package:login_todo/core/injection.dart';
import 'package:login_todo/domain/usecase/todo/todo_usecase.dart';
import 'package:login_todo/models/enums/todo_edit.dart';
import 'package:login_todo/models/todos/todo_model.dart';

class EditTodoBloc extends Bloc<EditTodoEvent, EditTodoState> {
  final UpdateTodoUseCase _updateTodoUseCase = getIt<UpdateTodoUseCase>();
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  EditTodoBloc({required TodoModel? initialTodo})
    : titleController = TextEditingController(text: initialTodo?.title ?? ''),
      descriptionController = TextEditingController(
        text: initialTodo?.description ?? '',
      ),
      super(
        EditTodoState(initialTodo: initialTodo, status: EditTodoStatus.initial),
      ) {
    on<EditSubmit>(_onEditSubmit);
  }

  Future<void> _onEditSubmit(
      EditSubmit event,
      Emitter<EditTodoState> emit,
      ) async {
    emit(state.copyWith(status: EditTodoStatus.loading));

    final updatedTodo = state.initialTodo!.copyWith(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
    );

    final currentTodos = await _updateTodoUseCase.rep.loadTodos();

    await _updateTodoUseCase.execute(
      updatedTodo,
      currentTodos,
    );

    emit(
      state.copyWith(
          status: EditTodoStatus.success,
          initialTodo: updatedTodo
      ),
    );
  }

  @override
  Future<void> close() {
    titleController.dispose();
    descriptionController.dispose();
    return super.close();
  }
}
