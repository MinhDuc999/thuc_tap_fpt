import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_todo/bloc/todo_bloc/todo_event.dart';
import 'package:login_todo/bloc/todo_bloc/todo_state.dart';
import 'package:login_todo/core/injection.dart';
import 'package:login_todo/domain/usecase/todo/todo_usecase.dart';
import 'package:login_todo/models/todos/todo_model.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final LoadTodosUseCase _loadTodosUseCase = getIt<LoadTodosUseCase>();
  final AddTodoUseCase _addTodoUseCase = getIt<AddTodoUseCase>();
  final ToggleTodoUseCase _toggleTodoUseCase = getIt<ToggleTodoUseCase>();
  final DeleteTodoUseCase _deleteTodoUseCase = getIt<DeleteTodoUseCase>();
  final UndoDeleteTodoUseCase _undoDeleteTodoUseCase = getIt<UndoDeleteTodoUseCase>();
  final UpdateTodoUseCase _updateTodoUseCase = getIt<UpdateTodoUseCase>();
  final ClearCompletedUseCase _clearCompletedUseCase = getIt<ClearCompletedUseCase>();
  final ToggleAllTodosUseCase _toggleAllTodosUseCase = getIt<ToggleAllTodosUseCase>();
  List<TodoModel> _cache = [];

  TodoBloc() : super(const TodoState()) {
    on<TodoLoadRequested>(_onLoad);
    on<TodoAddRequested>(_onAdd);
    on<TodoToggleRequested>(_onToggle);
    on<TodoDeleteRequested>(_onDelete);
    on<TodoClearCompletedRequested>(_onClearCompleted);
    on<TodoUpdateRequested>(_onUpdate);
    on<TodoOverviewFilterChanged>(_onFilterChanged);
    on<TodoUndoDeletionRequested>(_onUndoDelete);
    on<TodoToggleAllRequested>(_onToggleAll);
  }

  Future<void> _onLoad(TodoLoadRequested event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: TodoStatus.loading));
    try {
      final todos = await _loadTodosUseCase.execute();
      _cache = todos;
      emit(state.copyWith(status: TodoStatus.success, todos: List<TodoModel>.from(_cache)));
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onAdd(TodoAddRequested event, Emitter<TodoState> emit) async {
    final todos = await _addTodoUseCase.execute(event.title, event.description, _cache);
    _cache = todos;
    emit(state.copyWith(status: TodoStatus.success, todos: List<TodoModel>.from(_cache)));
  }

  Future<void> _onToggle(TodoToggleRequested event, Emitter<TodoState> emit) async {
    final todos = await _toggleTodoUseCase.execute(event.id, _cache);
    _cache = todos;
    emit(state.copyWith(status: TodoStatus.success, todos: List<TodoModel>.from(_cache)));
  }

  Future<void> _onDelete(TodoDeleteRequested event, Emitter<TodoState> emit) async {
    final (todos, todoToDelete) = await _deleteTodoUseCase.execute(event.id, _cache);
    _cache = todos;
    emit(state.copyWith(
      status: TodoStatus.success,
      todos: List<TodoModel>.from(_cache),
      lastDeletedTodo: todoToDelete,
    ));
  }

  Future<void> _onUndoDelete(TodoUndoDeletionRequested event, Emitter<TodoState> emit) async {
    final lastDeleted = state.lastDeletedTodo;
    if (lastDeleted != null) {
      final todos = await _undoDeleteTodoUseCase.execute(lastDeleted, _cache);
      _cache = todos;
      emit(state.copyWith(
        status: TodoStatus.success,
        todos: List<TodoModel>.from(_cache),
        lastDeletedTodo: null,
      ));
    }
  }

  Future<void> _onUpdate(TodoUpdateRequested event, Emitter<TodoState> emit) async {
    final existingTodo = _cache.firstWhere((t) => t.id == event.id);
    final updatedTodo = existingTodo.copyWith(
      title: event.newTitle ?? existingTodo.title,
      description: event.newDescription ?? existingTodo.description,
    );
    final todos = await _updateTodoUseCase.execute(updatedTodo, _cache);
    _cache = todos;
    emit(state.copyWith(
        status: TodoStatus.success,
        todos: List<TodoModel>.from(_cache)
    ));
  }

  Future<void> _onClearCompleted(TodoClearCompletedRequested event, Emitter<TodoState> emit) async {
    final todos = await _clearCompletedUseCase.execute(_cache);
    _cache = todos;
    emit(state.copyWith(status: TodoStatus.success, todos: List<TodoModel>.from(_cache)));
  }

  void _onFilterChanged(TodoOverviewFilterChanged event, Emitter<TodoState> emit) {
    emit(state.copyWith(filter: event.filter));
  }

  Future<void> _onToggleAll(TodoToggleAllRequested event, Emitter<TodoState> emit) async {
    final todos = await _toggleAllTodosUseCase.execute(_cache);
    _cache = todos;
    emit(state.copyWith(status: TodoStatus.success, todos: List<TodoModel>.from(_cache)));
  }
}