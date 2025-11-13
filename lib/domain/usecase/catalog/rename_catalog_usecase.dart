import 'package:ui_bang_gia/bloc/catalog/catalog_state.dart';

class RenameCatalogUseCase {
  CatalogState execute(CatalogState currentState, String oldName, String newName) {
    if (currentState.allCatalog.contains(newName)) {
      return currentState;
    }

    final updatedList = currentState.allCatalog.map((catalog) {
      return catalog == oldName ? newName : catalog;
    }).toList();

    final updatedSelectedCatalog =
    currentState.selectedCatalog == oldName ? newName : currentState.selectedCatalog;

    final updatedFilterCatalog = Map<String, List<String>>.from(currentState.filterCatalog);
    if (updatedFilterCatalog.containsKey(oldName)) {
      final stockList = updatedFilterCatalog[oldName]!;
      updatedFilterCatalog.remove(oldName);
      updatedFilterCatalog[newName] = stockList;
    }
    return currentState.copyWith(
      allCatalog: updatedList,
      selectedCatalog: updatedSelectedCatalog,
      filterCatalog: updatedFilterCatalog,
    );
  }
}