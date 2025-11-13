import 'package:ui_bang_gia/bloc/catalog/catalog_state.dart';

class ToggleCatalogUseCase{
  CatalogState execute(CatalogState currentState){
    return currentState.copyWith(
      isCatalogOpen: !currentState.isCatalogOpen,
    );
  }
}