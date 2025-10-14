import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_dieu_huong/bloc/core/injection.dart';
import 'package:ui_dieu_huong/bloc/navi_bloc/navi_event.dart';
import 'package:ui_dieu_huong/bloc/navi_bloc/navi_state.dart';
import 'package:ui_dieu_huong/doman/usecase/feature/all_feature_usecase.dart';
import 'package:ui_dieu_huong/doman/usecase/feature/remove_feature_usecase.dart';
import 'package:ui_dieu_huong/doman/usecase/feature/replace_feature_usecase.dart';
import 'package:ui_dieu_huong/doman/usecase/tab/change_button_usecase.dart';
import 'package:ui_dieu_huong/doman/usecase/tab/change_tab_usecase.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState>{
  final AllFeatureUsecase _allFeatureUsecase = getIt<AllFeatureUsecase>();
  final RemoveFeatureUsecase _removeFeatureUsecase = getIt<RemoveFeatureUsecase>();
  final ReplaceFeatureUsecase _replaceFeatureUsecase = getIt<ReplaceFeatureUsecase>();
  final ChangeTabUsecase _changeTabUsecase = getIt<ChangeTabUsecase>();
  final ChangeButtonUsecase _changeButtonUsecase = getIt<ChangeButtonUsecase>();
  NavigationBloc():super(NavigationState(
    selectedSlots: ["Trang chủ", "Sổ lệnh", "Đặt lệnh", "Tài sản", "Ứng dụng"],
    selected: ["Mặc định", "Mặc định", "Mặc định", "Mặc định", "Mặc định"],
    selectedIndex: 0,
    selectedTab: 0,
  )){
    on<AllFeature>(_onAllFeature);
    on<RemoveFeature>(_onRemoveFeature);
    on<ReplaceFeature>(_onReplaceFeature);
    on<ChangeTab>(_onChangeTab);
    on<ChangeButton>(_onChangeButton);
  }
  Future<void> _onAllFeature(
      AllFeature event, Emitter<NavigationState> emit) async {
    await _allFeatureUsecase.execute(
      state: state,
      event: event,
      emit: emit,
    );
  }

  Future<void> _onRemoveFeature(
      RemoveFeature event, Emitter<NavigationState> emit) async {
    await _removeFeatureUsecase.execute(
      state: state,
      event: event,
      emit: emit,
    );
  }
  Future<void> _onReplaceFeature(
      ReplaceFeature event,
      Emitter<NavigationState> emit) async {
    await _replaceFeatureUsecase.execute(
      state: state,
      event: event,
      emit: emit,
    );
  }

  Future<void> _onChangeTab(
      ChangeTab event, Emitter<NavigationState> emit) async {
    await _changeTabUsecase.execute(
      state: state,
      event: event,
      emit: emit,
    );
  }

  Future<void> _onChangeButton(
      ChangeButton event, Emitter<NavigationState> emit) async {
    await _changeButtonUsecase.execute(
      state: state,
      event: event,
      emit: emit,
    );
  }
}