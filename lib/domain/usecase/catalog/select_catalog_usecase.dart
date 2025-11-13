import 'package:ui_bang_gia/bloc/catalog/catalog_state.dart';

class SelectCatalogUseCase {
  CatalogState execute(CatalogState currentState, String category) {
    return currentState.copyWith(
      selectedCatalog: category,
    );
  }
}