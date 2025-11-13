import 'package:ui_bang_gia/bloc/market/market_menu_state.dart';

class ClearMarketSelectUseCase{
  MarketMenuState execute(MarketMenuState currentState) {
    return currentState.copyWith(
      clearSelectedCategory: true,
      clearSelectedParent: true,
      selectedSubItems: {},
    );
  }
}