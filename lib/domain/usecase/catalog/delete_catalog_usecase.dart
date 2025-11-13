import 'package:ui_bang_gia/bloc/catalog/catalog_state.dart';

class DeleteCatalogUseCase {
  CatalogState execute(CatalogState currentState, String name) {
    final updatedList = List<String>.from(currentState.allCatalog)..remove(name);

    // final updatedSelectedCatalog =
    // currentState.selectedCatalog == name ? null : currentState.selectedCatalog;

    return currentState.copyWith(
      allCatalog: updatedList,
      //clearSelectedCatalog: true,
    );
  }
}