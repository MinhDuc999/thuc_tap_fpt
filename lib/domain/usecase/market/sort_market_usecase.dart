import 'package:ui_bang_gia/models/stock/stock_model.dart';
import 'package:ui_bang_gia/bloc/stock/stock_state.dart';

class SortMarketUseCase {
  List<Stock> call({
    required List<Stock> stocks,
    required MarketSortColumn column,
    required bool ascending,
  }) {
    final newList = List<Stock>.from(stocks);

    switch (column) {
      case MarketSortColumn.symbol:
        newList.sort((a, b) => a.symbol.compareTo(b.symbol));
        break;

      case MarketSortColumn.khop:
        newList.sort((a, b) {
          final double aValue =
          (a.khop != null && a.khop!.isNotEmpty) ? a.khop![0] : double.negativeInfinity;
          final double bValue =
          (b.khop != null && b.khop!.isNotEmpty) ? b.khop![0] : double.negativeInfinity;
          return aValue.compareTo(bValue);
        });
        break;

      case MarketSortColumn.change:
        newList.sort((a, b) {
          final double aValue =
          (a.change != null && a.change!.isNotEmpty) ? a.change![0] : double.negativeInfinity;
          final double bValue =
          (b.change != null && b.change!.isNotEmpty) ? b.change![0] : double.negativeInfinity;
          return aValue.compareTo(bValue);
        });
        break;
    }

    if (!ascending) {
      newList.replaceRange(0, newList.length, newList.reversed);
    }

    return newList;
  }
}
