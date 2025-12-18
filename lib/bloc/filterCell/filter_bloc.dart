import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_bang_gia/bloc/filterCell/filterCell_event.dart';
import 'package:ui_bang_gia/bloc/filterCell/filterCell_state.dart';
import 'package:ui_bang_gia/core/injection.dart';
import 'package:ui_bang_gia/domain/usecase/filterCell/filter_cell_usecase.dart';

class FilterCellBloc extends Bloc<FilterCellEvent, FilterCellState> {
  final MoCuaUseCase _moCuaUseCase = getIt<MoCuaUseCase>();
  final NNMuaBanUseCase _nnMuaBanUseCase = getIt<NNMuaBanUseCase>();
  final MuaBan3UseCase _muaBan3UseCase = getIt<MuaBan3UseCase>();
  final SetKhoiLuongUseCase _setKhoiLuongUseCase = getIt<SetKhoiLuongUseCase>();
  final LoadFilterCellStateUseCase _loadFilterCellStateUseCase = getIt<LoadFilterCellStateUseCase>();


  FilterCellBloc() : super(FilterCellState()) {
    on<ToggleNNMuaBanEvent>((event, emit) {
      final newValue = _nnMuaBanUseCase.execute(state.showNNMuaBan);
      emit(state.copyWith(showNNMuaBan: newValue));
    });

    on<ToggleMoCuaEvent>((event, emit) {
      final newValue = _moCuaUseCase.execute(state.showMoCua);
      emit(state.copyWith(showMoCua: newValue));
    });

    on<ToggleGiaMuaBan3Event>((event, emit) {
      final newValue = _muaBan3UseCase.execute(state.showGiaMuaBan3);
      emit(state.copyWith(showGiaMuaBan3: newValue));
    });

    on<SetKhoiLuongEvent>((event, emit) {
      final newValue = _setKhoiLuongUseCase.execute(event.khoiLuong);
      emit(state.copyWith(khoiLuong: newValue));
    });

    on<InitializeFilterCellEvent>(_onInitialize);

    add(InitializeFilterCellEvent());
  }

  Future<void> _onInitialize(InitializeFilterCellEvent event, Emitter<FilterCellState> emit) async {
    final savedState = await _loadFilterCellStateUseCase.execute();

    if (savedState != null) {
      emit(FilterCellState(
        showNNMuaBan: savedState['showNNMuaBan'],
        showMoCua: savedState['showMoCua'],
        showGiaMuaBan3: savedState['showGiaMuaBan3'],
        khoiLuong: savedState['khoiLuong'],
      ));
    }
  }
}