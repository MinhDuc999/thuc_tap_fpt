abstract class MarketMenuRepository{
  Future<void> saveMarketMenuState({
    required bool isMenuOpen,
    String? selectedCategory,
    String? selectedParent,
    required Map<String, String> selectedSubItems,
  });
  Map<String, dynamic>? loadMarketMenuState();
  Future<void> clearMarketMenuState();
}