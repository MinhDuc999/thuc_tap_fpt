import 'package:ui_bang_gia/bloc/market/market_menu_state.dart';
import 'package:ui_bang_gia/core/injection.dart';
import 'package:ui_bang_gia/domain/repository/marketMenuRepository.dart';

class SelectSubMenuItemUseCase {
  final _repository = getIt<MarketMenuRepository>();

  MarketMenuState execute({
    required MarketMenuState currentState,
    required String subItem,
  }) {
    final updatedSubItems = <String, String>{};
    if (currentState.selectedParent != null) {
      updatedSubItems[currentState.selectedParent!] = subItem;
    }

    final newState = currentState.copyWith(
      selectedCategory: subItem,
      selectedSubItems: updatedSubItems,
      selectedParent: null,
    );

    _repository.saveMarketMenuState(
        isMenuOpen: newState.isMenuOpen,
        selectedCategory: newState.selectedCategory,
        selectedParent: newState.selectedParent,
        selectedSubItems: newState.selectedSubItems);
    return newState;
  }
}