import 'dart:convert';
import 'package:shared_core/core/injection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_bang_gia/domain/repository/stockRepository.dart';

class MarketRepositoryImpl implements MarketRepository{
  static const String _keySelectedCategory = 'market_selected_category';
  static const String _keyFilterMap = 'market_filter_map';
  final _prefs = getIt<SharedPreferences>();
  @override
  Future<void> clearMarketState() async {
    await _prefs.remove(_keySelectedCategory);
    await _prefs.remove(_keyFilterMap);
  }

  @override
  Map<String, dynamic>? loadMarketState() {
    try {
      final selectedCategory = _prefs.getString(_keySelectedCategory);
      final filterMapJson = _prefs.getString(_keyFilterMap);

      if (filterMapJson == null) return null;

      final Map<String, dynamic> filterMapDynamic = jsonDecode(filterMapJson);
      final Map<String, List<String>> filterMap = filterMapDynamic.map(
            (key, value) => MapEntry(key, List<String>.from(value)),
      );

      return {
        'selectedCategory': selectedCategory,
        'filterMap': filterMap,
      };
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveMarketState({String? selectedCategory, required Map<String, List<String>> filterMap}) async {
    if (selectedCategory != null) {
      await _prefs.setString(_keySelectedCategory, selectedCategory);
    } else {
      await _prefs.remove(_keySelectedCategory);
    }
    await _prefs.setString(_keyFilterMap, jsonEncode(filterMap));
  }

}