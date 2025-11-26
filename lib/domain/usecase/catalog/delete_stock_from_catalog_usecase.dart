import 'package:ui_bang_gia/bloc/catalog/catalog_state.dart';
import 'package:ui_bang_gia/core/injection.dart';
import 'package:ui_bang_gia/domain/repository/catalogRepository.dart';

class DeleteStockFromCatalogUseCase {
  final _repository = getIt<CatalogRepository>();
  CatalogState execute(CatalogState currentState, String catalogName, String stockSymbol) {
    final updatedFilterCatalog = Map<String, List<String>>.from(currentState.filterCatalog);
  print("delete");
    if (updatedFilterCatalog.containsKey(catalogName)) {
      final currentList = List<String>.from(updatedFilterCatalog[catalogName]!);
      currentList.remove(stockSymbol);
      updatedFilterCatalog[catalogName] = currentList;
    }

    final newState = currentState.copyWith(filterCatalog: updatedFilterCatalog);
    _repository.saveCatalogState(
        isCatalogOpen: newState.isCatalogOpen,
        selectedCatalog: newState.selectedCatalog,
        allCatalog: newState.allCatalog,
        filterCatalog: newState.filterCatalog);
    return newState;
  }
}