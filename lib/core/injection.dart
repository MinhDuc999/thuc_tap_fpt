import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_todo/data/repositories/auth/auth_repository_impl.dart';
import 'package:login_todo/data/service/auth/auth_service.dart';
import 'package:login_todo/data/repositories/todos/todo_repository_impl.dart';
import 'package:login_todo/data/service/todos/todo_service.dart';
import 'package:login_todo/domain/usecase/auth/auth_usecase.dart';
import 'package:login_todo/domain/usecase/stats/get_stats_usecase.dart';
import 'package:login_todo/domain/usecase/todo/todo_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/repositories/auth/auth_repository.dart';
import '../domain/repositories/todos/todo_repository.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);

  getIt.registerLazySingleton<AuthService>(
    () => AuthService(),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(),
  );

  getIt.registerLazySingleton<TodoService>(
    () => TodoService(),
  );

  getIt.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(),
  );

  getIt.registerLazySingleton<LogInUseCase>(() => LogInUseCase());
  getIt.registerLazySingleton<LogOutUseCase>(() => LogOutUseCase());
  getIt.registerLazySingleton<CheckAuthUseCase>(() => CheckAuthUseCase());
  getIt.registerLazySingleton<LoadTodosUseCase>(() => LoadTodosUseCase());
  getIt.registerLazySingleton<AddTodoUseCase>(() => AddTodoUseCase());
  getIt.registerLazySingleton<ToggleTodoUseCase>(() => ToggleTodoUseCase());
  getIt.registerLazySingleton<DeleteTodoUseCase>(() => DeleteTodoUseCase());
  getIt.registerLazySingleton<UndoDeleteTodoUseCase>(
    () => UndoDeleteTodoUseCase(),
  );
  getIt.registerLazySingleton<UpdateTodoUseCase>(() => UpdateTodoUseCase());
  getIt.registerLazySingleton<ClearCompletedUseCase>(
    () => ClearCompletedUseCase(),
  );
  getIt.registerLazySingleton<ToggleAllTodosUseCase>(
    () => ToggleAllTodosUseCase(),
  );

  getIt.registerLazySingleton<GetStatsUseCase>(() => GetStatsUseCase());

}
