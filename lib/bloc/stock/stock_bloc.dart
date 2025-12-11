import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_bang_gia/bloc/stock/stock_event.dart';
import 'package:ui_bang_gia/bloc/stock/stock_state.dart';
import 'package:ui_bang_gia/constants/market_filter.dart';
import 'package:ui_bang_gia/core/injection.dart';
import 'package:ui_bang_gia/domain/repository/price_board_repository.dart';
import 'package:ui_bang_gia/domain/usecase/market/market_usecase.dart';

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  final LoadMarketDataUseCase _loadMarketDataUseCase = getIt<LoadMarketDataUseCase>();
  final SortMarketDataUseCase _sortMarketDataUseCase = getIt<SortMarketDataUseCase>();
  final FilterMarketDataUseCase _filterMarketDataUseCase = getIt<FilterMarketDataUseCase>();

  MarketBloc() : super(MarketState(
    stocks: [],
    allStocks: [],
    sortedColumn: null,
    ascending: true,
    isLoading: true,
    selectedCategory: 'HOSE',
    filterMap: Map<String, List<String>>.from(MarketFilter.DEFAULT_FILTER_MAP),
  )) {
    on<MarketEventLoadMarket>(_onLoadMarket);
    on<MarketEventSort>(_onSort);
    on<MarketEventFilterByCategory>(_onFilterByCategory);
    on<InitializeMarketEvent>(_onInitialize);

    add(InitializeMarketEvent());
  }

  Future<void> _onInitialize(InitializeMarketEvent event, Emitter<MarketState> emit) async {
    final repository = getIt<MarketStateRepository>();
    final savedMarketState = await repository.loadMarketState();

    String? selectedCategory;
    Map<String, List<String>> filterMap = {};

    if (savedMarketState != null) {
      selectedCategory = savedMarketState['selectedCategory'] as String?;
      filterMap = savedMarketState['filterMap'] as Map<String, List<String>>? ?? {};
    } else {
      selectedCategory = 'HOSE';
      filterMap = Map<String, List<String>>.from(MarketFilter.DEFAULT_FILTER_MAP);
    }

    emit(state.copyWith(selectedCategory: selectedCategory, filterMap: filterMap,));

    add(MarketEventLoadMarket());
  }

  Future<void> _onLoadMarket(MarketEventLoadMarket event, Emitter<MarketState> emit) async {
    final result = await _loadMarketDataUseCase.execute(
      state.selectedCategory,
      state.filterMap,
    );

    emit(state.copyWith(
      stocks: result['stocks'],
      allStocks: result['allStocks'],
      isLoading: false,
    ));
  }

  void _onSort(MarketEventSort event, Emitter<MarketState> emit) {
    final sortedStocks = _sortMarketDataUseCase.execute(state.stocks, event.column, event.ascending,);

    emit(state.copyWith(
      stocks: sortedStocks,
      sortedColumn: event.column,
      ascending: event.ascending,
    ));
  }

  Future<void> _onFilterByCategory(MarketEventFilterByCategory event, Emitter<MarketState> emit) async {
    final filteredStocks = await _filterMarketDataUseCase.execute(state.allStocks, event.category, event.filterMap,);

    emit(state.copyWith(
      stocks: filteredStocks,
      selectedCategory: event.category,
      filterMap: event.filterMap,
      sortedColumn: null,
      ascending: true,
    ));
  }
}

