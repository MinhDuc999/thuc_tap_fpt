abstract class CatalogRepository {
  Future<void> saveCatalogState({
    String? selectedCatalog,
    List<String>? allCatalog,
    Map<String, List<String>>? filterCatalog,
  });
  Future<Map<String, dynamic>?> loadCatalogState();
  Future<void> clearCatalogState();
}

abstract class FilterCellRepository {
  Future<void> saveFilterCellState({
    bool? showNNMuaBan,
    bool? showMoCua,
    bool? showGiaMuaBan3,
    String? khoiLuong,
  });
  Future<Map<String, dynamic>?> loadFilterCellState();
  Future<void> clearFilterCellState();
}

abstract class MarketStateRepository {
  Future<void> saveMarketState({
    String? selectedCategory,
    Map<String, List<String>>? filterMap,
    Map<String, String>? selectedSubItems,
  });
  Future<Map<String, dynamic>?> loadMarketState();
  Future<void> clearMarketState();
}