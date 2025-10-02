import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_todo/bloc/auth_bloc/auth_bloc.dart';
import 'package:login_todo/bloc/auth_bloc/auth_state.dart';
import 'package:login_todo/models/enums/auth_status.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state){
          if(state.status == AuthStatus.authenticated ) return const HomePage();
          if(state.status == AuthStatus.unauthenticated || state.status == AuthStatus.failure) return const LoginPage();
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
