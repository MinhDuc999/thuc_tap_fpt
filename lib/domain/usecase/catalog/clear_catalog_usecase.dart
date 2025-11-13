import 'package:ui_bang_gia/bloc/catalog/catalog_state.dart';

class ClearCatalogUseCase{
  CatalogState execute(CatalogState currentState) {
    return currentState.copyWith(
      clearSelectedCatalog: true,
    );
  }
}