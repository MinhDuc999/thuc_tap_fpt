import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_bang_gia/bloc/stock/stock_event.dart';
import 'package:ui_bang_gia/bloc/stock/stock_state.dart';
import 'package:ui_bang_gia/core/injection.dart';
import 'package:ui_bang_gia/domain/usecase/market/filter_market_by_category_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/market/get_display_stocks_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/market/load_market_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/market/sort_market_usecase.dart';

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  final LoadMarketUseCase _loadMarket = getIt<LoadMarketUseCase>();
  final SortMarketUseCase _sortMarket = getIt<SortMarketUseCase>();
  final FilterMarketByCategoryUseCase _filterMarketByCategoryUseCase = getIt<FilterMarketByCategoryUseCase>();
  final GetDisplayStocksUseCase _getDisplayStocksUseCase = getIt<GetDisplayStocksUseCase>();
  MarketBloc() : super(MarketState(
      stocks: [],
      sortedColumn: null,
      ascending: true,
      allStocks: [],
      isLoading: true,
  )) {
    on<MarketEventLoadMarket>(_onLoadMarket);
    on<MarketEventLoadFirst>(_onLoadMarketFirst);
    on<MarketEventSort>(_onSort);
    on<MarketEventFilterByCategory>(_onFilterByCategory);
  }


  void _onLoadMarket(
      MarketEventLoadMarket event,
      Emitter<MarketState> emit,
      ) {
    final allStocks = _loadMarket();

    final displayStocks = _getDisplayStocksUseCase(
      allStocks: allStocks,
      selectedCategory: state.selectedCategory,
      filterMap: state.filterMap,
    );


    emit(state.copyWith(
      stocks: displayStocks,
      allStocks: allStocks,
      sortedColumn: null,
      ascending: true,
      isLoading: false,
    ));
  }

  void _onLoadMarketFirst(
      MarketEventLoadFirst event,
      Emitter<MarketState> emit,
      ) {
    final allStocks = _loadMarket();

    final defaultFilterMap = event.filterMap ?? {};


    final displayStocks = _getDisplayStocksUseCase(
      allStocks: allStocks,
      selectedCategory: 'HOSE',
      filterMap: defaultFilterMap,
    );

    emit(state.copyWith(
      stocks: displayStocks,
      allStocks: allStocks,
      sortedColumn: null,
      ascending: true,
      isLoading: false,
      selectedCategory: 'HOSE',
      filterMap: defaultFilterMap,
    ));
  }


  void _onSort(MarketEventSort event, Emitter<MarketState> emit) {
    final newList = _sortMarket(
      stocks: state.stocks,
      column: event.column,
      ascending: event.ascending,
    );

    emit(state.copyWith(
      stocks: newList,
      sortedColumn: event.column,
      ascending: event.ascending,
    ));
  }

  void _onFilterByCategory(
      MarketEventFilterByCategory event,
      Emitter<MarketState> emit,
      ) {
    final filteredStocks = _filterMarketByCategoryUseCase(
      allStocks: state.allStocks,
      category: event.category,
      filterMap: event.filterMap,
    );

    emit(state.copyWith(
      stocks: filteredStocks,
      selectedCategory: event.category,
      filterMap: event.filterMap,
      sortedColumn: null,
      ascending: true,
    ));
  }
}
