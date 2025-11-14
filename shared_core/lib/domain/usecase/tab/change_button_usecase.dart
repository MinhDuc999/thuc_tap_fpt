import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_core/bloc/navi_bloc/navi_event.dart';
import 'package:shared_core/bloc/navi_bloc/navi_state.dart';

class ChangeButtonUsecase {
  Future<void> execute({
    required NavigationState state,
    required ChangeButton event,
    required Emitter<NavigationState> emit,
  }) async {
    emit(state.copyWith(selectedIndex: event.index));
  }
}
