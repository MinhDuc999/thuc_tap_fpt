import 'package:ui_bang_gia/bloc/filterCell/filterCell_state.dart';
import 'package:ui_bang_gia/core/injection.dart';
import 'package:ui_bang_gia/domain/repository/filterCellRepository.dart';

class MuaBan3UseCase{
  final _repository = getIt<FilterCellRepository>();
  FilterCellState execute(FilterCellState currentState) {
    final newState = currentState.copyWith(showGiaMuaBan3: !currentState.showGiaMuaBan3);
    _repository.saveFilterCellState(
        showNNMuaBan: newState.showNNMuaBan,
        showMoCua: newState.showMoCua,
        showGiaMuaBan3: newState.showGiaMuaBan3,
        khoiLuong: newState.khoiLuong);
    return newState;
  }
}