import 'package:ui_bang_gia/bloc/market/market_menu_state.dart';

class SelectMarketCategoryUseCase {
  MarketMenuState execute({
    required MarketMenuState currentState,
    required String category,
    required bool hasSubmenu,
  }) {
    Map<String, String> updatedSubItems = Map.from(currentState.selectedSubItems);

    if (!hasSubmenu) {
      updatedSubItems.clear();
      return currentState.copyWith(
        selectedCategory: category,
        selectedParent: null,
        selectedSubItems: updatedSubItems,
      );
    } else {
      return currentState.copyWith(
        selectedParent: category,
        selectedCategory: currentState.selectedCategory ?? category,
        selectedSubItems: updatedSubItems,
      );
    }
  }
}