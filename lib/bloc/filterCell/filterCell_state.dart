import 'package:equatable/equatable.dart';

class FilterCellState extends Equatable{
  final bool showNNMuaBan;
  final bool showMoCua;
  final bool showGiaMuaBan3;
  final String khoiLuong;

  const FilterCellState({
    this.showNNMuaBan = true,
    this.showMoCua= false,
    this.showGiaMuaBan3= true,
    this.khoiLuong ="rutGon"
  });

  FilterCellState copyWith({
    bool? showNNMuaBan,
    bool? showMoCua,
    bool? showGiaMuaBan3,
    String? khoiLuong,
}) {
    return FilterCellState(
      showNNMuaBan: showNNMuaBan ?? this.showNNMuaBan,
      showMoCua: showMoCua ?? this.showMoCua,
      showGiaMuaBan3: showGiaMuaBan3 ?? this.showGiaMuaBan3,
      khoiLuong: khoiLuong ?? this.khoiLuong,
    );
  }

  @override
  List<Object?> get props => [showNNMuaBan,showMoCua,showGiaMuaBan3,khoiLuong];
}
