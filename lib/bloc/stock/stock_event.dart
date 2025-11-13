import 'package:equatable/equatable.dart';
import 'package:ui_bang_gia/bloc/stock/stock_state.dart';

abstract class MarketEvent extends Equatable{
  const MarketEvent();
}

class MarketEventLoadMarket extends MarketEvent {
  @override
  List<Object?> get props => [];
}

class MarketEventLoadFirst extends MarketEvent {
  final Map<String, List<String>>? filterMap;
  const MarketEventLoadFirst({this.filterMap});
  @override
  List<Object?> get props => [filterMap];
}

class MarketEventSort extends MarketEvent {
  final MarketSortColumn column;
  final bool ascending;

  const MarketEventSort({required this.column, required this.ascending});
  @override
  List<Object?> get props => [column,ascending];
}

class MarketEventFilterByCategory extends MarketEvent {
  final String category;
  final Map<String, List<String>> filterMap;

  const MarketEventFilterByCategory(this.category, this.filterMap);
  @override
  List<Object?> get props => [category,filterMap];
}





