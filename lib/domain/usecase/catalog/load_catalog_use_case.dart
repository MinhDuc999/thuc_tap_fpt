import 'package:ui_bang_gia/bloc/catalog/catalog_state.dart';

class LoadCatalogUseCase {
  CatalogState execute(CatalogState currentState, List<String> catalogs) {
    return currentState.copyWith(
      allCatalog: catalogs,
    );
  }
}