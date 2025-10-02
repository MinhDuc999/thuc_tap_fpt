import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_todo/bloc/home/home_state.dart';
import 'package:login_todo/bloc/todo_bloc/todo_bloc.dart';
import 'package:login_todo/bloc/todo_bloc/todo_event.dart';

class HomeCubit extends Cubit<HomeState> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TodoBloc todoBloc;

  HomeCubit({required this.todoBloc}) : super(const HomeState());

  void setTab(HomeTab tab) => emit(HomeState(tab: tab));

  void submitAddTodo() {
    final title = titleController.text.trim();
    final desc = descController.text.trim();
    if (title.isEmpty) return;
    todoBloc.add(TodoAddRequested(title, desc));
    titleController.clear();
    descController.clear();
  }

  @override
  Future<void> close() {
    titleController.dispose();
    descController.dispose();
    return super.close();
  }
}
