import 'package:ui_bang_gia/bloc/market/market_menu_state.dart';

class ToggleMarketMenuUseCase {
  MarketMenuState execute(MarketMenuState currentState) {
    return currentState.copyWith(
      isMenuOpen: !currentState.isMenuOpen,
      selectedParent: null,
    );
  }
}