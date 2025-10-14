import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_dieu_huong/bloc/navi_bloc/navi_event.dart';
import 'package:ui_dieu_huong/bloc/navi_bloc/navi_state.dart';

class ReplaceFeatureUsecase {
  Future<void> execute({
    required NavigationState state,
    required ReplaceFeature event,
    required Emitter<NavigationState> emit,
  }) async {
    final newSlots = List<String?>.from(state.selectedSlots);
    final draggedFeature = event.feature;
    final targetIndex = event.index;

    if ((targetIndex == 0 && draggedFeature != "Trang chủ") ||
        (targetIndex == 4 && draggedFeature != "Ứng dụng")) {
      return;
    }

    final currentIndex = newSlots.indexOf(draggedFeature);
    final replacedFeature = newSlots[targetIndex];
    if (currentIndex != -1) {
      newSlots[currentIndex] = replacedFeature;
      newSlots[targetIndex] = draggedFeature;
    } else {
      newSlots[targetIndex] = draggedFeature;
    }
    emit(state.copyWith(
      selectedSlots: newSlots
    ));
  }
}