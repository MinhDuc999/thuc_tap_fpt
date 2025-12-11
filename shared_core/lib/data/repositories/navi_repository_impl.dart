import 'dart:convert';
import 'package:shared_core/core/injection.dart';
import 'package:shared_core/data/database/database_helper.dart';
import 'package:shared_core/domain/repositories/navi_repository.dart';

class NavigationRepositoryImpl implements NavigationRepository {
  //final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final _dbHelper = getIt<DatabaseHelper>();

  @override
  Future<void> saveNavigationState({
    List<String?>? selectedSlots,
    int? selectedIndex,
  }) async {
    final db = await _dbHelper.database;

    final existing = await db.query(
      'navigation_state',
      where: 'id = ?',
      whereArgs: [1],
    );

    if (existing.isEmpty) {
      await db.insert('navigation_state', {
        'id': 1,
        'selected_slots': jsonEncode(selectedSlots ?? ["Trang chủ", "Sổ lệnh", "Đặt lệnh", "Tài sản", "Ứng dụng"]),
        'selected_index': selectedIndex ?? 0,
      });
    } else {
      final Map<String, dynamic> updateData = {};

      if (selectedSlots != null) {
        updateData['selected_slots'] = jsonEncode(selectedSlots);
      }
      if (selectedIndex != null) {
        updateData['selected_index'] = selectedIndex;
      }

      if (updateData.isNotEmpty) {
        await db.update(
          'navigation_state',
          updateData,
          where: 'id = ?',
          whereArgs: [1],
        );
      }
    }
  }

  @override
  Future<Map<String, dynamic>?> loadNavigationState() async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'navigation_state',
        where: 'id = ?',
        whereArgs: [1],
      );

      if (maps.isEmpty) return null;

      final data = maps.first;
      return {
        'selectedSlots': List<String?>.from(jsonDecode(data['selected_slots'])),
        'selectedIndex': data['selected_index'] as int,
      };
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearNavigationState() async {
    final db = await _dbHelper.database;
    await db.delete('navigation_state');
  }
}