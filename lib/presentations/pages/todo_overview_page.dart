import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_todo/bloc/todo_bloc/todo_bloc.dart';
import 'package:login_todo/bloc/todo_bloc/todo_state.dart';
import 'package:login_todo/bloc/todo_bloc/todo_event.dart';
import 'package:login_todo/presentations/pages/edit_todo_page.dart';



class TodoOverviewPage extends StatefulWidget {
  const TodoOverviewPage({super.key});

  @override
  State<TodoOverviewPage> createState() => _TodoOverviewPageState();
}

class _TodoOverviewPageState extends State<TodoOverviewPage> {
  late TodoBloc _todoBloc;

  @override
  void initState() {
    super.initState();
    _todoBloc = context.read<TodoBloc>();
    _todoBloc.add(TodoLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoBloc, TodoState>(
      bloc: _todoBloc,
      listenWhen: (previous, current) =>
      previous.lastDeletedTodo != current.lastDeletedTodo &&
          current.lastDeletedTodo != null,
      listener: (context, state) {
        final deletedTodo = state.lastDeletedTodo!;
        final message = ScaffoldMessenger.of(context);
        message
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('Đã xóa ${deletedTodo.title}'),
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  message.hideCurrentSnackBar();
                  _todoBloc.add(const TodoUndoDeletionRequested());
                },
              ),
            ),
          );
      },
      builder: (context, state) {
        if (state.status == TodoStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == TodoStatus.failure) {
          return Center(
            child: Text('Error: ${state.errorMessage ?? "Lỗi"}'),
          );
        }
        if (state.status == TodoStatus.success) {
          final todos = state.filteredTodos.toList();
          if (todos.isEmpty) {
            return const Center(child: Text('No todos'));
          }
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final t = todos[index];
              return Dismissible(
                key: ValueKey(t.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  _todoBloc.add(TodoDeleteRequested(t.id));
                  final message = ScaffoldMessenger.of(context);
                  message
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text('Đã xóa ${t.title}'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            _todoBloc.add(const TodoUndoDeletionRequested());
                          },
                        ),
                      ),
                    );
                },
                child: ListTile(
                  leading: Checkbox(
                    value: t.isCompleted,
                    onChanged: (_) =>
                        _todoBloc.add(TodoToggleRequested(t.id)),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(t.title), Text(t.description)],
                  ),
                  onTap: () async {
                    await Navigator.of(context)
                        .push(EditTodoPage.route(initialTodo: t));
                    if (context.mounted) {
                      _todoBloc.add(const TodoLoadRequested());
                    }
                  },
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
