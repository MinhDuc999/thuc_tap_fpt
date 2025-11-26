import 'package:ui_bang_gia/bloc/market/market_menu_state.dart';
import 'package:ui_bang_gia/core/injection.dart';
import 'package:ui_bang_gia/domain/repository/marketMenuRepository.dart';

class SelectMarketCategoryUseCase {
  final _repository = getIt<MarketMenuRepository>();
  MarketMenuState execute({
    required MarketMenuState currentState,
    required String category,
    required bool hasSubmenu,
  }) {
    Map<String, String> updatedSubItems = Map.from(currentState.selectedSubItems);

    MarketMenuState newState;
    if (!hasSubmenu) {
      updatedSubItems.clear();
      newState = currentState.copyWith(
        selectedCategory: category,
        selectedParent: null,
        selectedSubItems: updatedSubItems,
      );
    } else {
      newState = currentState.copyWith(
        selectedParent: category,
        selectedCategory: currentState.selectedCategory ?? category,
        selectedSubItems: updatedSubItems,
      );
    }

    _repository.saveMarketMenuState(
      isMenuOpen: newState.isMenuOpen,
      selectedCategory: newState.selectedCategory,
      selectedParent: newState.selectedParent,
      selectedSubItems: newState.selectedSubItems,);
    return newState;
  }
}