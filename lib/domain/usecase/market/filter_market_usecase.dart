import 'package:ui_bang_gia/models/stock/stock_model.dart';

class FilterMarketUseCase {
  List<Stock> call({
    required List<Stock> allStocks,
    required String? selectedCategory,
    required Map<String, List<String>>? filterMap,
  }) {
    if (selectedCategory == null || filterMap == null) {
      return [];
    }
    final filterSymbols = filterMap[selectedCategory] ?? [];
    if (filterSymbols.isEmpty) {
      return [];
    }
    return allStocks
        .where((stock) => filterSymbols.contains(stock.symbol))
        .toList();
  }
}