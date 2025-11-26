import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_bang_gia/core/injection.dart';
import 'package:ui_bang_gia/domain/repository/catalogRepository.dart';

class CatalogRepositoryImpl implements CatalogRepository{
  static const String _keyIsCatalogOpen = 'is_catalog_open';
  static const String _keySelectedCatalog = 'selected_catalog';
  static const String _keyAllCatalog = 'all_catalog';
  static const String _keyFilterCatalog = 'filter_catalog';
  final _prefs = getIt<SharedPreferences>();
  @override
  Future<void> clearCatalogState() async{
    await _prefs.remove(_keyIsCatalogOpen);
    await _prefs.remove(_keySelectedCatalog);
    await _prefs.remove(_keyAllCatalog);
    await _prefs.remove(_keyFilterCatalog);
  }

  @override
  Map<String, dynamic>? loadCatalogState() {
    try {
      final isCatalogOpen = _prefs.getBool(_keyIsCatalogOpen);
      final selectedCatalog = _prefs.getString(_keySelectedCatalog);
      final allCatalogJson = _prefs.getString(_keyAllCatalog);
      final filterCatalogJson = _prefs.getString(_keyFilterCatalog);

      if (allCatalogJson == null) return null;

      final Map<String, dynamic> filterCatalogMap = jsonDecode(filterCatalogJson ?? '{}');
      final Map<String, List<String>> typedFilterCatalog = filterCatalogMap.map(
            (key, value) => MapEntry(key, List<String>.from(value)),
      );

      return {
        'isCatalogOpen': isCatalogOpen ?? false,
        'selectedCatalog': selectedCatalog,
        'allCatalog': List<String>.from(jsonDecode(allCatalogJson)),
        'filterCatalog': typedFilterCatalog,
      };
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveCatalogState ({required bool isCatalogOpen, String? selectedCatalog, required List<String> allCatalog, required Map<String, List<String>> filterCatalog}) async{
    await _prefs.setBool(_keyIsCatalogOpen, isCatalogOpen);
    if (selectedCatalog != null) {
      await _prefs.setString(_keySelectedCatalog, selectedCatalog);
    } else {
      await _prefs.remove(_keySelectedCatalog);
    }
    await _prefs.setString(_keyAllCatalog, jsonEncode(allCatalog));
    await _prefs.setString(_keyFilterCatalog, jsonEncode(filterCatalog));
  }
  
}