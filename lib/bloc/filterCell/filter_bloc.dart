import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_bang_gia/bloc/filterCell/filterCell_event.dart';
import 'package:ui_bang_gia/bloc/filterCell/filterCell_state.dart';

class FilterCellBloc extends Bloc<FilterCellEvent,FilterCellState>{
  FilterCellBloc() : super(FilterCellState()){
    on<ToggleNNMuaBanEvent>((event,emit){
      emit(state.copyWith(showNNMuaBan: !state.showNNMuaBan));
    });
    on<ToggleMoCuaEvent>((event,emit){
      emit(state.copyWith(showMoCua: !state.showMoCua));
    });
    on<ToggleGiaMuaBan3Event>((event,emit){
      emit(state.copyWith(showGiaMuaBan3: !state.showGiaMuaBan3));
    });
    on<SetKhoiLuongEvent>((event,emit){
      emit(state.copyWith(khoiLuong: event.khoiLuong));
    });
  }
}
