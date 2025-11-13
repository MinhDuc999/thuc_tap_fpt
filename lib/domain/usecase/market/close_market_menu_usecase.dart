import 'package:ui_bang_gia/bloc/market/market_menu_state.dart';

class CloseMarketMenuUseCase {
  MarketMenuState execute(MarketMenuState currentState) {
    return MarketMenuState(
      isMenuOpen: false,
      selectedCategory: currentState.selectedCategory,
      selectedSubItems: currentState.selectedSubItems,
      selectedParent: null,
    );
  }
}