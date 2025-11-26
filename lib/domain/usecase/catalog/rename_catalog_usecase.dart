import 'package:ui_bang_gia/bloc/catalog/catalog_state.dart';
import 'package:ui_bang_gia/core/injection.dart';
import 'package:ui_bang_gia/domain/repository/catalogRepository.dart';

class RenameCatalogUseCase {
  final _repository = getIt<CatalogRepository>();
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

    final newState = currentState.copyWith(allCatalog: updatedList, selectedCatalog: updatedSelectedCatalog, filterCatalog: updatedFilterCatalog);
    _repository.saveCatalogState(
        isCatalogOpen: newState.isCatalogOpen,
        selectedCatalog: newState.selectedCatalog,
        allCatalog: newState.allCatalog,
        filterCatalog: newState.filterCatalog);
    return newState;
  }
}