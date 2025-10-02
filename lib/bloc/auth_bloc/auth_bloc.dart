import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_todo/bloc/auth_bloc/auth_event.dart';
import 'package:login_todo/bloc/auth_bloc/auth_state.dart';
import 'package:login_todo/core/injection.dart';
import 'package:login_todo/domain/repositories/auth/auth_repository.dart';
import 'package:login_todo/domain/usecase/auth/auth_usecase.dart';
import 'package:login_todo/models/enums/auth_status.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LogInUseCase _loginUseCase = getIt<LogInUseCase>();
  final LogOutUseCase _logoutUseCase = getIt<LogOutUseCase>();
  final CheckAuthUseCase _checkAuthUseCase = getIt<CheckAuthUseCase>();
  final AuthRepository _authRepository = getIt<AuthRepository>();
  StreamSubscription<bool>? _authSubscription;


  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AuthBloc(): super(const AuthState()) {
    on<AuthLogInRequested>(_onLogInRequested);
    on<AuthLogOutRequested>(_onLogOutRequested);
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthStateChanged>(_onAuthStateChanged);

    _startAuthListener();
  }

  void _startAuthListener() {
    _authSubscription = _authRepository.userChanges.listen((isLoggedIn) {
      add(AuthStateChanged(isLoggedIn));
    });
  }

  Future<void> _onLogInRequested(AuthLogInRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _loginUseCase.execute(event.email, event.password);
      emit(state.copyWith(status: AuthStatus.authenticated));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(status: AuthStatus.failure, message: e.message ?? "Lỗi đăng nhập"));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.failure, message: e.toString()));
    }
  }

  Future<void> _onLogOutRequested(AuthLogOutRequested event, Emitter<AuthState> emit) async {
    await _logoutUseCase.execute();
    emit(state.copyWith(status: AuthStatus.unauthenticated));
  }

  Future<void> _onCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) async {
    final isAuthenticated = await _checkAuthUseCase.execute();
    emit(state.copyWith(
      status: isAuthenticated ? AuthStatus.authenticated : AuthStatus.unauthenticated,
    ));
  }

  void _onAuthStateChanged(AuthStateChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(
      status: event.isLoggedIn ? AuthStatus.authenticated : AuthStatus.unauthenticated,
    ));
  }

  void submitLogin() {
    final email = emailController.text.trim();
    final password = passwordController.text;
    add(AuthLogInRequested(email: email, password: password));
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}