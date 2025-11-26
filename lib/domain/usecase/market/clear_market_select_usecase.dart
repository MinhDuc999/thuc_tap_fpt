import 'package:ui_bang_gia/bloc/market/market_menu_state.dart';
import 'package:ui_bang_gia/core/injection.dart';
import 'package:ui_bang_gia/domain/repository/marketMenuRepository.dart';

class ClearMarketSelectUseCase{
  final _repository = getIt<MarketMenuRepository>();
  MarketMenuState execute(MarketMenuState currentState) {
    final newState = currentState.copyWith(clearSelectedCategory: true, clearSelectedParent: true, selectedSubItems: {});
    _repository.saveMarketMenuState(
      isMenuOpen: newState.isMenuOpen,
      selectedCategory: newState.selectedCategory,
      selectedParent: newState.selectedParent,
      selectedSubItems: newState.selectedSubItems,);
    return newState;
  }
}