import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_core/bloc/navi_bloc/navi_event.dart';
import 'package:shared_core/bloc/navi_bloc/navi_state.dart';
import 'package:shared_core/core/injection.dart';
import 'package:shared_core/domain/repositories/navi_repository.dart';

class AllFeatureUseCase {
  final _repository = getIt<NavigationRepository>();
  Future<void> execute({
    required NavigationState state,
    required AllFeature event,
    required Emitter<NavigationState> emit,
  }) async {
    final emptyIndex = state.selectedSlots.indexWhere((e) => e == null);
    if (emptyIndex != -1) {
      final newSlots = List<String?>.from(state.selectedSlots);
      newSlots[emptyIndex] = event.feature;

      List<String>? updatedSearchResults = state.searchResults;
      if (state.searchResults != null) {
        updatedSearchResults = List<String>.from(state.searchResults!);
        updatedSearchResults.remove(event.feature);
      }

      List<String>? updatedRecentlyRemoved = state.recentlyRemovedFeature;
      if (updatedRecentlyRemoved != null) {
        updatedRecentlyRemoved = List<String>.from(updatedRecentlyRemoved);
        updatedRecentlyRemoved.remove(event.feature);
      }

      final newState = state.copyWith(
        selectedSlots: newSlots,
        searchResults: updatedSearchResults,
        recentlyRemovedFeature: updatedRecentlyRemoved,
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