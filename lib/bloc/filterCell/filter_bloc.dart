import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_bang_gia/bloc/filterCell/filterCell_event.dart';
import 'package:ui_bang_gia/bloc/filterCell/filterCell_state.dart';
import 'package:ui_bang_gia/core/injection.dart';
import 'package:ui_bang_gia/domain/repository/filterCellRepository.dart';
import 'package:ui_bang_gia/domain/usecase/filterCell/moCua_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/filterCell/muaBan3_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/filterCell/nnMuaBan_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/filterCell/set_khoi_luong_usecase.dart';

class FilterCellBloc extends Bloc<FilterCellEvent,FilterCellState>{
  final MoCuaUseCase _moCuaUseCase = getIt<MoCuaUseCase>();
  final NNMuaBanUseCase _nnMuaBanUseCase = getIt<NNMuaBanUseCase>();
  final MuaBan3UseCase _muaBan3UseCase = getIt<MuaBan3UseCase>();
  final SetKhoiLuongUseCase _setKhoiLuongUseCase = getIt<SetKhoiLuongUseCase>();
  FilterCellBloc() : super(_loadInitialState()){
    on<ToggleNNMuaBanEvent>((event,emit){
      emit(_nnMuaBanUseCase.execute(state));
    });
    on<ToggleMoCuaEvent>((event,emit){
      emit(_moCuaUseCase.execute(state));
    });
    on<ToggleGiaMuaBan3Event>((event,emit){
      emit(_muaBan3UseCase.execute(state));
    });
    on<SetKhoiLuongEvent>((event,emit){
      emit(_setKhoiLuongUseCase.execute(state, event.khoiLuong));
    });
  }

  static FilterCellState _loadInitialState() {
    final repository = getIt<FilterCellRepository>();
    final savedState = repository.loadFilterCellState();

    if (savedState != null) {
      return FilterCellState(
        showNNMuaBan: savedState['showNNMuaBan'],
        showMoCua: savedState['showMoCua'],
        showGiaMuaBan3: savedState['showGiaMuaBan3'],
        khoiLuong: savedState['khoiLuong'],
      );
    }
    return FilterCellState();
  }
}
