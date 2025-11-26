import 'package:ui_bang_gia/bloc/catalog/catalog_state.dart';
import 'package:ui_bang_gia/core/injection.dart';
import 'package:ui_bang_gia/domain/repository/catalogRepository.dart';

class AddStockToCatalogUseCase {
  final _repository = getIt<CatalogRepository>();
  CatalogState execute(CatalogState currentState, String catalogName, String stockSymbol) {
    final updatedFilterCatalog = Map<String, List<String>>.from(currentState.filterCatalog);

    if (!updatedFilterCatalog.containsKey(catalogName)) {
      updatedFilterCatalog[catalogName] = [];
    }

    final currentStocks = updatedFilterCatalog[catalogName]!;

    if (currentStocks.contains(stockSymbol)) {
      return currentState;
    }

    final updatedStocks = List<String>.from(currentStocks)..add(stockSymbol);
    updatedFilterCatalog[catalogName] = updatedStocks;

    final newState = currentState.copyWith(filterCatalog: updatedFilterCatalog);
    _repository.saveCatalogState(
        isCatalogOpen: newState.isCatalogOpen,
        selectedCatalog: newState.selectedCatalog,
        allCatalog: newState.allCatalog,
        filterCatalog: newState.filterCatalog);

    return newState;
  }
}