import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_core/bloc/navi_bloc/navi_event.dart';
import 'package:shared_core/bloc/navi_bloc/navi_state.dart';
import 'package:shared_core/core/injection.dart';
import 'package:shared_core/domain/repositories/navi_repository.dart';

class ReplaceFeatureUseCase {
  final _repository = getIt<NavigationRepository>();
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

      List<String>? updatedSearchResults = state.searchResults;
      if (state.searchResults != null) {
        updatedSearchResults = List<String>.from(state.searchResults!);
        updatedSearchResults.remove(draggedFeature);

        if (replacedFeature != null) {
          updatedSearchResults.remove(replacedFeature);
          updatedSearchResults.insert(0, replacedFeature);
        }
      }

      List<String> updatedRecentlyRemoved = state.recentlyRemovedFeature != null
          ? List<String>.from(state.recentlyRemovedFeature!)
          : [];

      if (replacedFeature != null) {
        updatedRecentlyRemoved.remove(replacedFeature);
        updatedRecentlyRemoved.insert(0, replacedFeature);
      }

    final newState = state.copyWith(
      selectedSlots: newSlots,
      recentlyRemovedFeature: updatedRecentlyRemoved,
      searchResults: updatedSearchResults,
    );

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