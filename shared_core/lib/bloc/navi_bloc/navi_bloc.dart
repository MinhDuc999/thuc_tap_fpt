import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_core/bloc/navi_bloc/navi_event.dart';
import 'package:shared_core/bloc/navi_bloc/navi_state.dart';
import 'package:shared_core/core/injection.dart';
import 'package:shared_core/domain/repositories/navi_repository.dart';
import 'package:shared_core/domain/usecase/feature/feature_usecase.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  final AllFeatureUseCase _allFeatureUseCase = getIt<AllFeatureUseCase>();
  final RemoveFeatureUseCase _removeFeatureUseCase = getIt<RemoveFeatureUseCase>();
  final ReplaceFeatureUseCase _replaceFeatureUseCase = getIt<ReplaceFeatureUseCase>();
  final SearchFeatureUseCase _searchFeatureUseCase = getIt<SearchFeatureUseCase>();
  final OpenSearchViewUseCase _openSearchViewUseCase = getIt<OpenSearchViewUseCase>();
  final CloseSearchViewUseCase _closeSearchViewUseCase = getIt<CloseSearchViewUseCase>();
  final ChangeTabUseCase _changeTabUseCase = getIt<ChangeTabUseCase>();
  final ChangeButtonUseCase _changeButtonUseCase = getIt<ChangeButtonUseCase>();

  NavigationBloc() : super(NavigationState(
    selectedSlots: ["home", "order_book", "place_order", "assets", "apps"],
    selected: ["Mặc định", null, null, null, null],
    selectedIndex: 0,
    selectedTab: 0,
  )) {
    on<AllFeature>(_onAllFeature);
    on<RemoveFeature>(_onRemoveFeature);
    on<ReplaceFeature>(_onReplaceFeature);
    on<SearchFeature>(_onSearchFeature);
    on<OpenSearchView>(_onOpenSearchView);
    on<CloseSearchView>(_onCloseSearchView);
    on<ChangeTab>(_onChangeTab);
    on<ChangeButton>(_onChangeButton);
    on<InitializeNavigationEvent>(_onInitialize);

    add(InitializeNavigationEvent());
  }

  Future<void> _onInitialize(InitializeNavigationEvent event, Emitter<NavigationState> emit) async {
    final repository = getIt<NavigationRepository>();
    final savedState = await repository.loadNavigationState();

    if (savedState != null) {
      emit(NavigationState(
        selectedSlots: savedState['selectedSlots'],
        selected: ["Mặc định", null, null, null, null],
        selectedIndex: savedState['selectedIndex'],
        selectedTab: 0,
      ));
    }
  }

  Future<void> _onAllFeature(AllFeature event, Emitter<NavigationState> emit) async {
    final updatedSlots = await _allFeatureUseCase.execute(
      AllFeatureParams(
        feature: event.feature,
        currentSlots: state.selectedSlots,
      ),
    );

    if (updatedSlots != null) {
      // UI tự xử lý việc filter searchResults và recentlyRemoved
      emit(state.copyWith(
        selectedSlots: updatedSlots,
        // Không cần pass searchResults và recentlyRemoved vào UseCase nữa
      ));
    }
  }

  Future<void> _onRemoveFeature(RemoveFeature event, Emitter<NavigationState> emit) async {
    final result = await _removeFeatureUseCase.execute(
      RemoveFeatureParams(
        feature: event.feature,
        currentSlots: state.selectedSlots,
        currentSearchResults: state.searchResults,
        recentlyRemoved: state.recentlyRemovedFeature,
      ),
    );

    if (result != null) {
      emit(state.copyWith(
        selectedSlots: result['updatedSlots'],
        searchResults: result['updatedSearchResults'],
        recentlyRemovedFeature: result['updatedRecentlyRemoved'],
      ));
    }
  }

  Future<void> _onReplaceFeature(ReplaceFeature event, Emitter<NavigationState> emit) async {
    final result = await _replaceFeatureUseCase.execute(
      ReplaceFeatureParams(
        feature: event.feature,
        targetIndex: event.index,
        currentSlots: state.selectedSlots,
        currentSearchResults: state.searchResults,
        recentlyRemoved: state.recentlyRemovedFeature,
      ),
    );

    if (result != null) {
      emit(state.copyWith(
        selectedSlots: result['updatedSlots'],
        searchResults: result['updatedSearchResults'],
        recentlyRemovedFeature: result['updatedRecentlyRemoved'],
      ));
    }
  }

  void _onSearchFeature(SearchFeature event, Emitter<NavigationState> emit) {
    final result = _searchFeatureUseCase.execute(
      SearchFeatureParams(
        query: event.query,
        currentSlots: state.selectedSlots,
      ),
    );

    emit(state.copyWith(
      searchResults: result,
      searchQuery: event.query,
      recentlyRemovedFeature: event.query.isEmpty ? null : state.recentlyRemovedFeature,
    ));
  }

  void _onOpenSearchView(OpenSearchView event, Emitter<NavigationState> emit) {
    final isOpen = _openSearchViewUseCase.execute(state.isSearchViewOpen);
    emit(state.copyWith(isSearchViewOpen: isOpen));
  }

  void _onCloseSearchView(CloseSearchView event, Emitter<NavigationState> emit) {
    _closeSearchViewUseCase.execute(searchFocusNode);
    emit(state.copyWith(isSearchViewOpen: false));
  }

  Future<void> _onChangeTab(ChangeTab event, Emitter<NavigationState> emit) async {
    await _changeTabUseCase.execute(event.index);
    emit(state.copyWith(selectedTab: event.index));
  }

  Future<void> _onChangeButton(ChangeButton event, Emitter<NavigationState> emit) async {
    await _changeButtonUseCase.execute(event.index);
    emit(state.copyWith(selectedIndex: event.index));
  }

  @override
  Future<void> close() {
    searchController.dispose();
    searchFocusNode.dispose();
    return super.close();
  }
}