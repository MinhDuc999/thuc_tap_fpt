abstract class CatalogRepository{
  Future<void> saveCatalogState({
    required bool isCatalogOpen,
    required String? selectedCatalog,
    required List<String> allCatalog,
    required Map<String, List<String>> filterCatalog,
  });
  Map<String,dynamic>? loadCatalogState();
  Future<void> clearCatalogState();
}