import 'package:ui_bang_gia/bloc/stock/stock_state.dart';
import 'package:ui_bang_gia/core/injection.dart';
import 'package:ui_bang_gia/domain/repository/price_board_repository.dart';
import 'package:ui_bang_gia/domain/usecase/market/filter_market_by_category_usecase.dart';
import 'package:ui_bang_gia/models/stock/stock_model.dart';
import 'package:ui_bang_gia/domain/usecase/market/load_market_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/market/get_display_stocks_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/market/sort_market_usecase.dart';

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
  final bool hasSubmenu;
  final String? currentSelectedCategory;
  final Map<String, String> currentSelectedSubItems;

  SelectMarketCategoryParams({
    required this.category,
    required this.hasSubmenu,
    required this.currentSelectedCategory,
    required this.currentSelectedSubItems,
  });
}

class SelectMarketCategoryUseCase {
  final _repository  = getIt<MarketStateRepository>();

  Future<Map<String, dynamic>> execute(SelectMarketCategoryParams params) async {
    Map<String, String> updatedSubItems = Map.from(params.currentSelectedSubItems);

    if (!params.hasSubmenu) {
      updatedSubItems.clear();

      await _repository .saveMarketState(selectedCategory: params.category, selectedSubItems: updatedSubItems);

      return {
        'selectedCategory': params.category,
        'selectedParent': null,
        'selectedSubItems': updatedSubItems,
      };
    } else {
      return {
        'selectedCategory': params.currentSelectedCategory ?? params.category,
        'selectedParent': params.category,
        'selectedSubItems': updatedSubItems,
      };
    }
  }
}

//Chọn item của market
class SelectSubMenuItemUseCase {
  final _repository  = getIt<MarketStateRepository>();

  Future<Map<String, dynamic>> execute(String subItem, String? currentSelectedParent) async {
    final updatedSubItems = <String, String>{};
    if (currentSelectedParent != null) {
      updatedSubItems[currentSelectedParent] = subItem;
    }

    await _repository .saveMarketState(selectedCategory: subItem, selectedSubItems: updatedSubItems);

    return {
      'selectedCategory': subItem,
      'selectedParent': null,
      'selectedSubItems': updatedSubItems,
    };
  }
}

//Hiển thị các mã
class LoadMarketDataUseCase {
  final LoadMarketUseCase _loadMarket = getIt<LoadMarketUseCase>();
  final GetDisplayStocksUseCase _getDisplayStocksUseCase = getIt<GetDisplayStocksUseCase>();

  Future<Map<String, List<Stock>>> execute(String? selectedCategory, Map<String, List<String>>? filterMap) async {
    final allStocks = _loadMarket();
    final displayStocks = _getDisplayStocksUseCase(
      allStocks: allStocks,
      selectedCategory: selectedCategory,
      filterMap: filterMap,
    );

    return {
      'stocks': displayStocks,
      'allStocks': allStocks,
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
  final FilterMarketByCategoryUseCase _filterMarketByCategoryUseCase = getIt<FilterMarketByCategoryUseCase>();

  Future<List<Stock>> execute(List<Stock> allStocks, String category, Map<String, List<String>> filterMap,) async {
    final filteredStocks = _filterMarketByCategoryUseCase(allStocks: allStocks, category: category, filterMap: filterMap,);

    await _repository.saveMarketState(selectedCategory: category, filterMap: filterMap,);

    return filteredStocks;
  }
}