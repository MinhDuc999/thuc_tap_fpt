import 'package:ui_bang_gia/models/stock/stock_model.dart';

class GetDisplayStocksUseCase {
  List<Stock> call({
    required List<Stock> allStocks,
    String? selectedCategory,
    Map<String, List<String>>? filterMap,
  }) {
    if (selectedCategory == null) {
      return allStocks;
    }

    if (filterMap == null || filterMap.isEmpty) {
      return [];
    }

    final filterSymbols = filterMap[selectedCategory];

    if (filterSymbols == null || filterSymbols.isEmpty) {
      return [];
    }

    return allStocks
        .where((stock) => filterSymbols.contains(stock.symbol))
        .toList();
  }
}