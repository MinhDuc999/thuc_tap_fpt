import 'package:ui_bang_gia/bloc/catalog/catalog_state.dart';
import 'package:ui_bang_gia/core/injection.dart';
import 'package:ui_bang_gia/domain/repository/catalogRepository.dart';

class ToggleCatalogUseCase{
  final _repository = getIt<CatalogRepository>();
  CatalogState execute(CatalogState currentState){
    final newState = currentState.copyWith(isCatalogOpen: !currentState.isCatalogOpen);
    _repository.saveCatalogState(
        isCatalogOpen: newState.isCatalogOpen,
        selectedCatalog: newState.selectedCatalog,
        allCatalog: newState.allCatalog,
        filterCatalog: newState.filterCatalog);
    return newState;
  }
}