import 'package:ui_bang_gia/bloc/catalog/catalog_state.dart';
import 'package:ui_bang_gia/core/injection.dart';
import 'package:ui_bang_gia/domain/repository/catalogRepository.dart';

class DeleteCatalogUseCase {
  final _repository = getIt<CatalogRepository>();
  CatalogState execute(CatalogState currentState, String name) {
    final updatedList = List<String>.from(currentState.allCatalog)..remove(name);
    final newState = currentState.copyWith(allCatalog: updatedList);
    _repository.saveCatalogState(
        isCatalogOpen: newState.isCatalogOpen,
        selectedCatalog: newState.selectedCatalog,
        allCatalog: newState.allCatalog,
        filterCatalog: newState.filterCatalog);

    return newState;
  }
}