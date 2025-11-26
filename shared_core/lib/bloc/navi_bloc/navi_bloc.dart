import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_core/bloc/navi_bloc/navi_event.dart';
import 'package:shared_core/bloc/navi_bloc/navi_state.dart';
import 'package:shared_core/core/injection.dart';
import 'package:shared_core/domain/repositories/navi_repository.dart';
import 'package:shared_core/domain/usecase/feature/all_feature_usecase.dart';
import 'package:shared_core/domain/usecase/feature/close_search_view_usecase.dart';
import 'package:shared_core/domain/usecase/feature/open_search_view_usecase.dart';
import 'package:shared_core/domain/usecase/feature/remove_feature_usecase.dart';
import 'package:shared_core/domain/usecase/feature/replace_feature_usecase.dart';
import 'package:shared_core/domain/usecase/feature/search_feature_usecase.dart';
import 'package:shared_core/domain/usecase/tab/change_button_usecase.dart';
import 'package:shared_core/domain/usecase/tab/change_tab_usecase.dart';


class NavigationBloc extends Bloc<NavigationEvent, NavigationState>{
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
  NavigationBloc():super(_loadInitState()){
    on<AllFeature>(_onAllFeature);
    on<RemoveFeature>(_onRemoveFeature);
    on<ReplaceFeature>(_onReplaceFeature);
    on<SearchFeature>(_onSearchFeature);
    on<OpenSearchView>(_onOpenSearchView);
    on<CloseSearchView>(_onCloseSearchView);
    on<ChangeTab>(_onChangeTab);
    on<ChangeButton>(_onChangeButton);
  }

  static NavigationState _loadInitState(){
    final repository = getIt<NavigationRepository>();
    final savedState = repository.loadState();
    if (savedState != null) {
      return NavigationState(
        selectedSlots: savedState['selectedSlots'],
        selected: savedState['selected'],
        selectedIndex: savedState['selectedIndex'],
        selectedTab: 0,
      );
    }

    return NavigationState(
      selectedSlots: ["Trang chủ", "Sổ lệnh", "Đặt lệnh", "Tài sản", "Ứng dụng"],
      selected: ["Mặc định", null, null, null, null],
      selectedIndex: 0,
      selectedTab: 0,
    );
  }

  Future<void> _onAllFeature(AllFeature event, Emitter<NavigationState> emit) async {
    await _allFeatureUseCase.execute(state: state, event: event, emit: emit);
  }

  Future<void> _onRemoveFeature(RemoveFeature event, Emitter<NavigationState> emit) async {
    await _removeFeatureUseCase.execute(state: state, event: event, emit: emit);
  }
  Future<void> _onReplaceFeature(ReplaceFeature event, Emitter<NavigationState> emit) async {
    await _replaceFeatureUseCase.execute(state: state, event: event, emit: emit);
  }

  Future<void> _onSearchFeature(SearchFeature event, Emitter<NavigationState> emit) async{
    await _searchFeatureUseCase.execute(state: state, event: event, emit: emit);
  }

  void _onOpenSearchView(OpenSearchView event, Emitter<NavigationState> emit){
    final newState = _openSearchViewUseCase.execute(state);
    emit(newState);
  }

  void _onCloseSearchView(CloseSearchView event, Emitter<NavigationState > emit) {
    final newState = _closeSearchViewUseCase.execute(state, focusNode: searchFocusNode);
    emit(newState);
  }

  Future<void> _onChangeTab(ChangeTab event, Emitter<NavigationState> emit) async {
    await _changeTabUseCase.execute(state: state, event: event, emit: emit);
  }

  Future<void> _onChangeButton(ChangeButton event, Emitter<NavigationState> emit) async {
    await _changeButtonUseCase.execute(state: state, event: event, emit: emit);
  }

  @override
  Future<void> close() {
    searchController.dispose();
    searchFocusNode.dispose();
    return super.close();
  }
}