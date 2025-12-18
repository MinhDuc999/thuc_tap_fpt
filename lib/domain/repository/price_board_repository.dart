abstract class CatalogRepository {
  Future<Map<String, dynamic>?> loadCatalogState();
  Future<void> clearCatalogState();
  Future<void> saveSelectedCatalog(String selectedCatalog);
  Future<void> clearSelectedCatalog();
  Future<void> saveAllCatalog(List<String> allCatalog);
  Future<void> saveFilterCatalog(Map<String, List<String>> filterCatalog);
  Future<void> saveCatalogState({
    String? selectedCatalog,
    List<String>? allCatalog,
    Map<String, List<String>>? filterCatalog,
  });
}

abstract class FilterCellRepository {
  Future<Map<String, dynamic>?> loadFilterCellState();
  Future<void> clearFilterCellState();
  Future<void> saveShowNNMuaBan(bool showNNMuaBan);
  Future<void> saveShowMoCua(bool showMoCua);
  Future<void> saveShowGiaMuaBan3(bool showGiaMuaBan3);
  Future<void> saveKhoiLuong(String khoiLuong);
}

abstract class MarketStateRepository {
  Future<Map<String, dynamic>?> loadMarketState();
  Future<void> clearMarketState();
  Future<void> saveMarketState({
    String? selectedCategory,
    Map<String, List<String>>? filterMap,
    Map<String, String>? selectedSubItems,
  });
}