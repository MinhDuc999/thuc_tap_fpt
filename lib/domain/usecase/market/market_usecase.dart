import 'package:ui_bang_gia/bloc/stock/stock_state.dart';
import 'package:ui_bang_gia/core/injection.dart';
import 'package:ui_bang_gia/domain/repository/price_board_repository.dart';
import 'package:ui_bang_gia/models/stock/stock_model.dart';
import 'package:ui_bang_gia/domain/usecase/market/sort_market_usecase.dart';

//Load dữ liệu
class LoadMarketStateUseCase {
  final _repository = getIt<MarketStateRepository>();

  Future<Map<String, dynamic>?> execute() async {
    return await _repository.loadMarketState();
  }
}

//Mở menu
class ToggleMarketMenuUseCase {
  bool execute(bool currentIsOpen) {
    return !currentIsOpen;
  }
}

//Đóng menu
class CloseMarketMenuUseCase {
  bool execute() {
    return false;
  }
}

//Clear market được chọn
class ClearMarketSelectUseCase {
  final _repository = getIt<MarketStateRepository>();

  Future<void> execute() async {
    await _repository.saveMarketState(selectedCategory: null, selectedSubItems: {});
  }
}

//Chọn mã market
class SelectMarketCategoryParams {
  final String category;
  final String? parentCategory;
  final Map<String, String> currentSelectedSubItems;

  SelectMarketCategoryParams({
    required this.category,
    this.parentCategory,
    required this.currentSelectedSubItems,
  });
}

class SelectMarketCategoryUseCase {
  final _marketRepository = getIt<MarketStateRepository>();

  Future<Map<String, dynamic>> execute(SelectMarketCategoryParams params) async {
    if (params.parentCategory != null) {
      final updatedSubItems = {params.parentCategory!: params.category};
      await _marketRepository.saveMarketState(selectedCategory: params.category, selectedSubItems: updatedSubItems,);


      return {
        'selectedCategory': params.category,
        'selectedSubItems': updatedSubItems,
      };
    }

    await _marketRepository.saveMarketState(selectedCategory: params.category, selectedSubItems: {});

    return {
      'selectedCategory': params.category,
      'selectedSubItems': <String, String>{},
    };
  }
}

//Sắp xếp
class SortMarketDataUseCase {
  final SortMarketUseCase _sortMarket = getIt<SortMarketUseCase>();

  List<Stock> execute(List<Stock> stocks, MarketSortColumn column, bool ascending,) {
    return _sortMarket(stocks: stocks, column: column, ascending: ascending,);
  }
}

//Hiển thị mã đã được chọn
class FilterMarketDataUseCase {
  final _repository = getIt<MarketStateRepository>();

  Future<List<Stock>> execute(List<Stock> allStocks, String category, Map<String, List<String>> filterMap) async {
    final filteredStocks = _filterByCategory(
      allStocks: allStocks,
      category: category,
      filterMap: filterMap,
    );

    await _repository.saveMarketState(selectedCategory: category, filterMap: filterMap);
    return filteredStocks;
  }

  List<Stock> _filterByCategory({required List<Stock> allStocks, required String category, required Map<String, List<String>> filterMap,}) {
    final filterSymbols = filterMap[category];
    if (filterSymbols == null || filterSymbols.isEmpty) {
      return [];
    }
    return allStocks.where((stock) => filterSymbols.contains(stock.symbol)).toList();
  }
}