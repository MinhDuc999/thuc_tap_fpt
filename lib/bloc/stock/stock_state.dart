import 'package:equatable/equatable.dart';
import 'package:ui_bang_gia/models/stock/stock_model.dart';

enum MarketSortColumn { symbol, khop, change }

class MarketState extends Equatable{
  final List<Stock> stocks;
  final MarketSortColumn? sortedColumn;
  final bool ascending;
  final List<Stock> allStocks;
  final String? selectedCategory;
  final bool isLoading;
  final Map<String, List<String>>? filterMap;

  const MarketState({
    required this.stocks,
    this.sortedColumn,
    this.ascending = true,
    required this.allStocks,
    this.selectedCategory,
    this.isLoading = false,
    this.filterMap,
  });

  MarketState copyWith({
    List<Stock>? stocks,
    MarketSortColumn? sortedColumn,
    bool? ascending,
    List<Stock>? allStocks,
    String? selectedCategory,
    bool clearSelectedCategory = false,
    bool? isLoading,
    Map<String, List<String>>? filterMap,
  }) {
    return MarketState(
      stocks: stocks ?? this.stocks,
      sortedColumn: sortedColumn,
      ascending: ascending ?? this.ascending,
      allStocks: allStocks ?? this.allStocks,
      selectedCategory: clearSelectedCategory ? null : (selectedCategory ?? this.selectedCategory),
      isLoading: isLoading ?? this.isLoading,
      filterMap: filterMap ?? this.filterMap,
    );
  }
  @override
  List<Object?> get props => [stocks,sortedColumn,ascending,allStocks, selectedCategory,isLoading,filterMap];
}