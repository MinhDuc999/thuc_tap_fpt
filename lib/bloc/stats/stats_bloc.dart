import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_todo/bloc/stats/stats_event.dart';
import 'package:login_todo/bloc/stats/stats_state.dart';
import 'package:login_todo/core/injection.dart';
import 'package:login_todo/domain/usecase/stats/get_stats_usecase.dart';
import 'package:login_todo/models/enums/stats.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final GetStatsUseCase _getStatsUseCase = getIt<GetStatsUseCase>();

  StatsBloc() :super(const StatsState()) {
    on<StatsRequested>(_onRequested);
  }

  Future<void> _onRequested(StatsRequested event, Emitter<StatsState> emit) async {
    emit(state.copyWith(status: StatsStatus.loading));
    await emit.forEach<(int, int)>(
      _getStatsUseCase.execute(),
      onData: (stats) => state.copyWith(
        status: StatsStatus.success,
        completed: stats.$1,
        active: stats.$2,
      ),
      onError: (_, _) => state.copyWith(status: StatsStatus.failure),
    );
  }
}