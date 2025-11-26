import 'package:ui_bang_gia/bloc/filterCell/filterCell_state.dart';
import 'package:ui_bang_gia/core/injection.dart';
import 'package:ui_bang_gia/domain/repository/filterCellRepository.dart';

class NNMuaBanUseCase{
  final _repository = getIt<FilterCellRepository>();
  FilterCellState execute(FilterCellState currentState) {
    final newState = currentState.copyWith(showNNMuaBan: !currentState.showNNMuaBan);
    _repository.saveFilterCellState(
        showNNMuaBan: newState.showNNMuaBan,
        showMoCua: newState.showMoCua,
        showGiaMuaBan3: newState.showGiaMuaBan3,
        khoiLuong: newState.khoiLuong);
    return newState;
  }
}