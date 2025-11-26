import 'package:ui_bang_gia/models/stock/stock_model.dart';

class FilterMarketByCategoryUseCase {
  List<Stock> call({
    required List<Stock> allStocks,
    required String category,
    required Map<String, List<String>> filterMap,
  }) {
    final filterSymbols = filterMap[category];

    if (filterSymbols == null || filterSymbols.isEmpty) {
      return [];
    }

    return allStocks
        .where((stock) => filterSymbols.contains(stock.symbol))
        .toList();
  }
}