abstract class FilterCellRepository{
  Future<void> saveFilterCellState({
    required bool showNNMuaBan,
    required bool showMoCua,
    required bool showGiaMuaBan3,
    required String khoiLuong,
  });
  Map<String,dynamic>? loadFilterCellState();
  Future<void> clearFilterCellState();
}