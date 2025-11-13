import 'package:ui_bang_gia/bloc/catalog/catalog_state.dart';

class AddCatalogUseCase {
  CatalogState execute(CatalogState currentState, String name) {
    if (currentState.allCatalog.contains(name)) {
      return currentState;
    }
    final updatedList = List<String>.from(currentState.allCatalog)..add(name);
    return currentState.copyWith(
      allCatalog: updatedList,
    );
  }
}