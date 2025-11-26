import 'package:ui_bang_gia/bloc/stock/stock_state.dart';
import 'package:ui_bang_gia/domain/repository/stockRepository.dart';
import 'package:ui_bang_gia/domain/usecase/market/filter_market_by_category_usecase.dart';
import 'package:ui_bang_gia/core/injection.dart';

class FilterMarketDataUseCase {
  final _repository = getIt<MarketRepository>();
  final FilterMarketByCategoryUseCase _filterMarketByCategoryUseCase = getIt<FilterMarketByCategoryUseCase>();

  Future<MarketState> execute({
    required MarketState state,
    required String category,
    required Map<String, List<String>> filterMap,
  }) async {
    final filteredStocks = _filterMarketByCategoryUseCase(
      allStocks: state.allStocks,
      category: category,
      filterMap: filterMap,
    );

    final newState = state.copyWith(
      stocks: filteredStocks,
      selectedCategory: category,
      filterMap: filterMap,
      sortedColumn: null,
      ascending: true,
    );

    await _saveState(newState);
    return newState;
  }

  Future<void> _saveState(MarketState state) async {
    await _repository.saveMarketState(
      selectedCategory: state.selectedCategory,
      filterMap: state.filterMap ?? {},
    );
  }
}