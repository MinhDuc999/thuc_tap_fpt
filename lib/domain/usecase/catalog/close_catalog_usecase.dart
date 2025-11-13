import 'package:ui_bang_gia/bloc/catalog/catalog_state.dart';

class CloseCatalogUseCase {
  CatalogState execute(CatalogState currentState) {
    return currentState.copyWith(
      isCatalogOpen: false,
      selectedCatalog: currentState.selectedCatalog,
    );
  }
}