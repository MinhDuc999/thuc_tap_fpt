import 'package:ui_bang_gia/bloc/market/market_menu_state.dart';

class SelectSubMenuItemUseCase {
  MarketMenuState execute({
    required MarketMenuState currentState,
    required String subItem,
  }) {
    final updatedSubItems = <String, String>{};
    if (currentState.selectedParent != null) {
      updatedSubItems[currentState.selectedParent!] = subItem;
    }

    return currentState.copyWith(
      selectedCategory: subItem,
      selectedSubItems: updatedSubItems,
      selectedParent: null,
    );
  }
}