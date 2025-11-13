import 'package:ui_bang_gia/bloc/catalog/catalog_state.dart';

class AddStockToCatalogUseCase {
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

    return currentState.copyWith(
      filterCatalog: updatedFilterCatalog,
    );
  }
}