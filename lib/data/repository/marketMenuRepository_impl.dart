import 'dart:convert';
import 'package:shared_core/core/injection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_bang_gia/domain/repository/marketMenuRepository.dart';

class MarketMenuRepositoryImpl implements MarketMenuRepository{
  static const String _keyIsMenuOpen = 'is_menu_open';
  static const String _keySelectedCategory = 'selected_category';
  static const String _keySelectedParent = 'selected_parent';
  static const String _keySelectedSubItems = 'selected_sub_items';
  final _prefs = getIt<SharedPreferences>();

  @override
  Future<void> clearMarketMenuState() async {
    await _prefs.remove(_keyIsMenuOpen);
    await _prefs.remove(_keySelectedCategory);
    await _prefs.remove(_keySelectedParent);
    await _prefs.remove(_keySelectedSubItems);
  }

  @override
  Map<String, dynamic>? loadMarketMenuState() {
    try {
      final isMenuOpen = _prefs.getBool(_keyIsMenuOpen);
      final selectedCategory = _prefs.getString(_keySelectedCategory);
      final selectedParent = _prefs.getString(_keySelectedParent);
      final selectedSubItemsJson = _prefs.getString(_keySelectedSubItems);

      final Map<String, String> selectedSubItems = selectedSubItemsJson != null
          ? Map<String, String>.from(jsonDecode(selectedSubItemsJson))
          : {};

      return {
        'isMenuOpen': isMenuOpen ?? false,
        'selectedCategory': selectedCategory,
        'selectedParent': selectedParent,
        'selectedSubItems': selectedSubItems,
      };
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveMarketMenuState({required bool isMenuOpen, String? selectedCategory, String? selectedParent, required Map<String, String> selectedSubItems}) async {
    await _prefs.setBool(_keyIsMenuOpen, isMenuOpen);
    if (selectedCategory != null) {
      await _prefs.setString(_keySelectedCategory, selectedCategory);
    } else {
      await _prefs.remove(_keySelectedCategory);
    }
    if (selectedParent != null) {
      await _prefs.setString(_keySelectedParent, selectedParent);
    } else {
      await _prefs.remove(_keySelectedParent);
    }
    await _prefs.setString(_keySelectedSubItems, jsonEncode(selectedSubItems));
  }

}