import 'package:ui_bang_gia/bloc/catalog/catalog_state.dart';

class DeleteStockFromCatalogUseCase {
  CatalogState execute(CatalogState currentState, String catalogName, String stockSymbol) {
    final updatedFilterCatalog = Map<String, List<String>>.from(currentState.filterCatalog);
  print("delete");
    if (updatedFilterCatalog.containsKey(catalogName)) {
      final currentList = List<String>.from(updatedFilterCatalog[catalogName]!);
      currentList.remove(stockSymbol);
      updatedFilterCatalog[catalogName] = currentList;
    }

    return currentState.copyWith(
      filterCatalog: updatedFilterCatalog,
    );
  }
}