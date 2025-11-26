import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_core/bloc/navi_bloc/navi_event.dart';
import 'package:shared_core/bloc/navi_bloc/navi_state.dart';
import 'package:shared_core/core/injection.dart';
import 'package:shared_core/domain/repositories/navi_repository.dart';

class ChangeButtonUseCase {
  final _repository = getIt<NavigationRepository>();
  Future<void> execute({
    required NavigationState state,
    required ChangeButton event,
    required Emitter<NavigationState> emit,
  }) async {
    final newState = state.copyWith(selectedIndex: event.index);
    if(newState.hasEnoughSelected){
      await _repository.saveState(
          selectedSlots: newState.selectedSlots,
          selected: newState.selected,
          selectedIndex: newState.selectedIndex,
          selectedTab: newState.selectedTab);
    }
    emit(newState);
  }
}
