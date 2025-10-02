import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_todo/bloc/stats/stats_bloc.dart';
import 'package:login_todo/bloc/stats/stats_event.dart';
import 'package:login_todo/bloc/stats/stats_state.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StatsBloc()..add(StatsRequested()),
      child: const StatsView(),
    );
  }
}

class StatsView extends StatefulWidget {
  const StatsView({super.key});

  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  late StatsBloc _statsBloc;

  @override
  void initState() {
    super.initState();
    _statsBloc = context.read<StatsBloc>();
    _statsBloc.add(StatsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsBloc, StatsState>(
      bloc: _statsBloc,
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.check_rounded),
                title: const Text('Đã hoàn thành'),
                trailing: Text('${state.completed}'),
              ),
              ListTile(
                leading: const Icon(Icons.radio_button_unchecked_rounded),
                title: const Text('Chưa hoàn thành'),
                trailing: Text('${state.active}'),
              ),
            ],
          ),
        );
      },
    );
  }
}
