import 'package:ui_bang_gia/bloc/stock/stock_state.dart';
import 'package:ui_bang_gia/domain/repository/stockRepository.dart';
import 'package:ui_bang_gia/domain/usecase/market/load_market_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/market/get_display_stocks_usecase.dart';
import 'package:ui_bang_gia/core/injection.dart';

class LoadMarketDataUseCase {
  final _repository = getIt<MarketRepository>();
  final LoadMarketUseCase _loadMarket = getIt<LoadMarketUseCase>();
  final GetDisplayStocksUseCase _getDisplayStocksUseCase = getIt<GetDisplayStocksUseCase>();

  Future<MarketState> execute(MarketState currentState) async {

    final allStocks = _loadMarket();
    final displayStocks = _getDisplayStocksUseCase(
      allStocks: allStocks,
      selectedCategory: currentState.selectedCategory,
      filterMap: currentState.filterMap,
    );


    final newState = currentState.copyWith(
      stocks: displayStocks,
      allStocks: allStocks,
      sortedColumn: null,
      ascending: true,
      isLoading: false,
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