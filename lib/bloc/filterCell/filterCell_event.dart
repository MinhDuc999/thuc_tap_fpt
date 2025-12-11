import 'package:equatable/equatable.dart';

abstract class FilterCellEvent extends Equatable{}

class ToggleNNMuaBanEvent extends FilterCellEvent {
  @override
  List<Object?> get props => [];
}
class ToggleMoCuaEvent extends FilterCellEvent {
  @override
  List<Object?> get props => [];
}
class ToggleGiaMuaBan3Event extends FilterCellEvent {
  @override
  List<Object?> get props => [];
}
class SetKhoiLuongEvent extends FilterCellEvent {
  final String khoiLuong;
  SetKhoiLuongEvent(this.khoiLuong);
  @override
  List<Object?> get props => [khoiLuong];
}
class InitializeFilterCellEvent extends FilterCellEvent {
  @override
  List<Object?> get props => [];
}