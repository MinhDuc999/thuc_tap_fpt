import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_bang_gia/bloc/stock/stock_event.dart';
import 'package:ui_bang_gia/bloc/stock/stock_state.dart';
import 'package:ui_bang_gia/constants/market_filter.dart';
import 'package:ui_bang_gia/core/injection.dart';
import 'package:ui_bang_gia/domain/repository/stockRepository.dart';
import 'package:ui_bang_gia/domain/usecase/market/filter_market_data_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/market/load_market_data_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/market/sort_market_data_usecase.dart';

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  final LoadMarketDataUseCase _loadMarketDataUseCase = getIt<LoadMarketDataUseCase>();
  final SortMarketDataUseCase _sortMarketDataUseCase = getIt<SortMarketDataUseCase>();
  final FilterMarketDataUseCase _filterMarketDataUseCase = getIt<FilterMarketDataUseCase>();

  MarketBloc() : super(_loadInitialState()) {
    on<MarketEventLoadMarket>(_onLoadMarket);
    on<MarketEventSort>(_onSort);
    on<MarketEventFilterByCategory>(_onFilterByCategory);

    add(MarketEventLoadMarket());
  }

  static MarketState _loadInitialState() {
    final repository = getIt<MarketRepository>();
    final savedMarketState = repository.loadMarketState();

    String? selectedCategory;
    Map<String, List<String>> filterMap = {};

    if (savedMarketState != null) {
      selectedCategory = savedMarketState['selectedCategory'] as String?;
      filterMap = savedMarketState['filterMap'] as Map<String, List<String>>? ?? {};

    } else {
      selectedCategory = 'HOSE';
      filterMap = Map<String, List<String>>.from(MarketFilter.DEFAULT_FILTER_MAP);
    }

    return MarketState(
      stocks: [],
      allStocks: [],
      sortedColumn: null,
      ascending: true,
      isLoading: true,
      selectedCategory: selectedCategory,
      filterMap: filterMap,
    );
  }


  Future<void> _onLoadMarket(MarketEventLoadMarket event, Emitter<MarketState> emit) async {
    final newState = await _loadMarketDataUseCase.execute(state);
    emit(newState);
  }

  void _onSort(MarketEventSort event, Emitter<MarketState> emit) {
    emit(_sortMarketDataUseCase.execute(
      state: state,
      column: event.column,
      ascending: event.ascending,
    ));
  }

  Future<void> _onFilterByCategory(MarketEventFilterByCategory event, Emitter<MarketState> emit) async {
    final newState = await _filterMarketDataUseCase.execute(
      state: state,
      category: event.category,
      filterMap: event.filterMap,
    );
    emit(newState);
  }
}
