import 'package:ui_bang_gia/core/injection.dart';
import 'package:ui_bang_gia/domain/repository/price_board_repository.dart';

class LoadFilterCellStateUseCase {
  final _repository = getIt<FilterCellRepository>();

  Future<Map<String, dynamic>?> execute() async {
    return await _repository.loadFilterCellState();
  }
}
class MoCuaUseCase {
  final _repository = getIt<FilterCellRepository>();

  bool execute(bool currentShowMoCua) {
    final newValue = !currentShowMoCua;
    _repository.saveShowMoCua(newValue);
    return newValue;
  }
}

class NNMuaBanUseCase {
  final _repository = getIt<FilterCellRepository>();

  bool execute(bool currentShowNNMuaBan) {
    final newValue = !currentShowNNMuaBan;
    _repository.saveShowNNMuaBan(newValue);
    return newValue;
  }
}

class MuaBan3UseCase {
  final _repository = getIt<FilterCellRepository>();

  bool execute(bool currentShowGiaMuaBan3) {
    final newValue = !currentShowGiaMuaBan3;
    _repository.saveShowGiaMuaBan3(newValue);
    return newValue;
  }
}

class SetKhoiLuongUseCase {
  final _repository = getIt<FilterCellRepository>();

  String execute(String khoiLuong) {
    _repository.saveKhoiLuong(khoiLuong);
    return khoiLuong;
  }
}