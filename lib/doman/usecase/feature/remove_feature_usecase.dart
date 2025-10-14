import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_dieu_huong/bloc/navi_bloc/navi_event.dart';
import 'package:ui_dieu_huong/bloc/navi_bloc/navi_state.dart';

class RemoveFeatureUsecase {
  Future<void> execute({
    required NavigationState state,
    required RemoveFeature event,
    required Emitter<NavigationState> emit,
  }) async {
    final newSlots = List<String?>.from(state.selectedSlots);
    final index = newSlots.indexOf(event.feature);
    if (index != -1) {
      newSlots[index] = null;
      emit(state.copyWith(selectedSlots: newSlots));
    }
  }
}