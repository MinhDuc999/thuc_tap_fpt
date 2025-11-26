import 'dart:convert';
import 'package:shared_core/core/injection.dart';
import 'package:shared_core/domain/repositories/navi_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationRepositoryImpl implements NavigationRepository{
  static const String _keySelectedSlots = 'selected_slots';
  static const String _keySelected = 'selected';
  static const String _keySelectedIndex = 'selected_index';
  static const String _keySelectedTab = 'selected_tab';

  final _prefs = getIt<SharedPreferences>();

  @override
  Future<void> clearState() async{
    await _prefs.remove(_keySelectedSlots);
    await _prefs.remove(_keySelected);
    await _prefs.remove(_keySelectedIndex);
    await _prefs.remove(_keySelectedTab);
  }

  @override
  Map<String, dynamic>? loadState() {
    try {
      final slotsJson = _prefs.getString(_keySelectedSlots);
      final selectedJson = _prefs.getString(_keySelected);
      final selectedIndex = _prefs.getInt(_keySelectedIndex);
      final selectedTab = _prefs.getInt(_keySelectedTab);

      if (slotsJson == null) return null;

      return {
        'selectedSlots': List<String?>.from(jsonDecode(slotsJson)),
        'selected': List<String?>.from(jsonDecode(selectedJson ?? '[]')),
        'selectedIndex': selectedIndex ?? 0,
        'selectedTab': selectedTab ?? 0,
      };
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveState({required List<String?> selectedSlots, required List<String?> selected, required int selectedIndex, required int selectedTab}) async{
    await _prefs.setString(_keySelectedSlots, jsonEncode(selectedSlots));
    await _prefs.setString(_keySelected, jsonEncode(selected));
    await _prefs.setInt(_keySelectedIndex, selectedIndex);
    await _prefs.setInt(_keySelectedTab, selectedTab);
  }
  
}