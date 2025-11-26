import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_core/bloc/navi_bloc/navi_event.dart';
import 'package:shared_core/bloc/navi_bloc/navi_state.dart';

class SearchFeatureUseCase {
  Future<void> execute({
    required NavigationState state,
    required SearchFeature event,
    required Emitter<NavigationState> emit,
  }) async {
    final query = event.query.toLowerCase().trim();

    if (query.isEmpty) {
      emit(state.copyWith(
        searchResults: [],
        searchQuery: '',
        recentlyRemovedFeature: null,
      ));
      return;
    }

    final searchList = event.allFeatures ?? [];

    final results = searchList.where((feature) =>
    feature.toLowerCase().startsWith(query) && !state.selectedSlots.contains(feature)).toList();

    emit(state.copyWith(
      searchResults: results,
      searchQuery: event.query,
    ));
  }
}