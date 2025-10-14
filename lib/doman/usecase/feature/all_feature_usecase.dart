import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_dieu_huong/bloc/navi_bloc/navi_event.dart';
import 'package:ui_dieu_huong/bloc/navi_bloc/navi_state.dart';

class AllFeatureUsecase {
  Future<void> execute({
    required NavigationState state,
    required AllFeature event,
    required Emitter<NavigationState> emit,
  }) async {
    final emptyIndex = state.selectedSlots.indexWhere((e) => e == null);
    if (emptyIndex != -1) {
      final newSlots = List<String?>.from(state.selectedSlots);
      newSlots[emptyIndex] = event.feature;
      emit(state.copyWith(selectedSlots: newSlots));
    }
  }
}