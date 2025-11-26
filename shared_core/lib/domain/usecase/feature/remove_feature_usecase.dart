import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_core/bloc/navi_bloc/navi_event.dart';
import 'package:shared_core/bloc/navi_bloc/navi_state.dart';
import 'package:shared_core/core/injection.dart';
import 'package:shared_core/domain/repositories/navi_repository.dart';

class RemoveFeatureUseCase {
  final _repository = getIt<NavigationRepository>();
  Future<void> execute({
    required NavigationState state,
    required RemoveFeature event,
    required Emitter<NavigationState> emit,
  }) async {
    final newSlots = List<String?>.from(state.selectedSlots);
    final index = newSlots.indexOf(event.feature);
    if (index != -1) {
      newSlots[index] = null;

      List<String>? updatedSearchResults = state.searchResults;
      if (state.searchResults != null) {
        updatedSearchResults = List<String>.from(state.searchResults!);
        updatedSearchResults.remove(event.feature);
        updatedSearchResults.insert(0, event.feature);
      }

      List<String> updatedRecentlyRemoved = state.recentlyRemovedFeature != null
          ? List<String>.from(state.recentlyRemovedFeature!)
          : [];
      updatedRecentlyRemoved.remove(event.feature);
      updatedRecentlyRemoved.insert(0, event.feature);

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
}