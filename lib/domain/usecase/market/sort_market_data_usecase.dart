import 'package:ui_bang_gia/bloc/stock/stock_state.dart';
import 'package:ui_bang_gia/domain/repository/stockRepository.dart';
import 'package:ui_bang_gia/domain/usecase/market/sort_market_usecase.dart';
import 'package:ui_bang_gia/core/injection.dart';

class SortMarketDataUseCase {
  final _repository = getIt<MarketRepository>();
  final SortMarketUseCase _sortMarket = getIt<SortMarketUseCase>();


  MarketState execute({
    required MarketState state,
    required MarketSortColumn column,
    required bool ascending,
  }) {
    final newList = _sortMarket(
      stocks: state.stocks,
      column: column,
      ascending: ascending,
    );

    final newState = state.copyWith(
      stocks: newList,
      sortedColumn: column,
      ascending: ascending,
    );

    _saveState(newState);
    return newState;
  }

  Future<void> _saveState(MarketState state) async {
    if (state.selectedCategory != null && state.filterMap != null) {
      await _repository.saveMarketState(
        selectedCategory: state.selectedCategory,
        filterMap: state.filterMap!,
      );
    }
  }
}