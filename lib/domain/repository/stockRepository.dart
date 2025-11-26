abstract class MarketRepository{
  Future<void> saveMarketState({
    String? selectedCategory,
    required Map<String, List<String>> filterMap,
  });
  Map<String, dynamic>? loadMarketState();
  Future<void> clearMarketState();
}