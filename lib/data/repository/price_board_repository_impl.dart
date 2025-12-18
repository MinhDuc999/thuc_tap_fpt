import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:ui_bang_gia/core/injection.dart';
import 'package:ui_bang_gia/data/database/database_helper.dart';
import '../../domain/repository/price_board_repository.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  final _dbHelper = getIt<DatabaseHelper>();

  @override
  Future<void> saveSelectedCatalog(String selectedCatalog) async {
    final db = await _dbHelper.database;
    await _ensureRowExists(db);

    await db.update(
      'catalog_state',
      {'selected_catalog': selectedCatalog},
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  @override
  Future<void> clearSelectedCatalog() async {
    final db = await _dbHelper.database;
    await _ensureRowExists(db);

    await db.update(
      'catalog_state',
      {'selected_catalog': null},
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  @override
  Future<void> saveAllCatalog(List<String> allCatalog) async {
    final db = await _dbHelper.database;
    await _ensureRowExists(db);

    await db.update(
      'catalog_state',
      {'all_catalog': jsonEncode(allCatalog)},
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  @override
  Future<void> saveFilterCatalog(Map<String, List<String>> filterCatalog) async {
    final db = await _dbHelper.database;
    await _ensureRowExists(db);

    await db.update(
      'catalog_state',
      {'filter_catalog': jsonEncode(filterCatalog)},
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  @override
  Future<void> saveCatalogState({
    String? selectedCatalog,
    List<String>? allCatalog,
    Map<String, List<String>>? filterCatalog,
  }) async {
    final db = await _dbHelper.database;
    await _ensureRowExists(db);

    final Map<String, dynamic> updateData = {};
    if (selectedCatalog != null) {
      updateData['selected_catalog'] = selectedCatalog;
    }
    if (allCatalog != null) {
      updateData['all_catalog'] = jsonEncode(allCatalog);
    }
    if (filterCatalog != null) {
      updateData['filter_catalog'] = jsonEncode(filterCatalog);
    }

    if (updateData.isNotEmpty) {
      await db.update(
        'catalog_state',
        updateData,
        where: 'id = ?',
        whereArgs: [1],
      );
    }
  }

  Future<void> _ensureRowExists(Database db) async {
    final existing = await db.query(
      'catalog_state',
      where: 'id = ?',
      whereArgs: [1],
    );

    if (existing.isEmpty) {
      await db.insert('catalog_state', {
        'id': 1,
        'selected_catalog': null,
        'all_catalog': jsonEncode([]),
        'filter_catalog': jsonEncode({}),
      },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  @override
  Future<void> clearCatalogState() async {
    final db = await _dbHelper.database;
    await db.delete('catalog_state');
  }

  @override
  Future<Map<String, dynamic>?> loadCatalogState() async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> results = await db.query(
        'catalog_state',
        where: 'id = ?',
        whereArgs: [1],
      );

      if (results.isEmpty) return null;

      final row = results.first;

      final Map<String, dynamic> filterCatalogMap = jsonDecode(row['filter_catalog'] as String);
      final Map<String, List<String>> typedFilterCatalog = filterCatalogMap.map(
            (key, value) => MapEntry(key, List<String>.from(value)),
      );

      return {
        'selectedCatalog': row['selected_catalog'] as String?,
        'allCatalog': List<String>.from(jsonDecode(row['all_catalog'] as String)),
        'filterCatalog': typedFilterCatalog,
      };
    } catch (e) {
      return null;
    }
  }
}

class FilterCellRepositoryImpl implements FilterCellRepository {
  final _dbHelper = getIt<DatabaseHelper>();

  @override
  Future<void> saveShowNNMuaBan(bool showNNMuaBan) async {
    final db = await _dbHelper.database;
    await _ensureRowExists(db);
    await db.update(
      'filter_cell_state',
      {'show_nn_mua_ban': showNNMuaBan ? 1 : 0},
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  @override
  Future<void> saveShowMoCua(bool showMoCua) async {
    final db = await _dbHelper.database;
    await _ensureRowExists(db);
    await db.update(
      'filter_cell_state',
      {'show_mo_cua': showMoCua ? 1 : 0},
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  @override
  Future<void> saveShowGiaMuaBan3(bool showGiaMuaBan3) async {
    final db = await _dbHelper.database;
    await _ensureRowExists(db);
    await db.update(
      'filter_cell_state',
      {'show_gia_mua_ban_3': showGiaMuaBan3 ? 1 : 0},
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  @override
  Future<void> saveKhoiLuong(String khoiLuong) async {
    final db = await _dbHelper.database;
    await _ensureRowExists(db);
    await db.update(
      'filter_cell_state',
      {'khoi_luong': khoiLuong},
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  Future<void> _ensureRowExists(Database db) async {
    final existing = await db.query(
      'filter_cell_state',
      where: 'id = ?',
      whereArgs: [1],
    );

    if (existing.isEmpty) {
      await db.insert('filter_cell_state', {
        'id': 1,
        'show_nn_mua_ban': 1,
        'show_mo_cua': 0,
        'show_gia_mua_ban_3': 1,
        'khoi_luong': 'rutGon',
      },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  @override
  Future<void> clearFilterCellState() async {
    final db = await _dbHelper.database;
    await db.delete('filter_cell_state');
  }

  @override
  Future<Map<String, dynamic>?> loadFilterCellState() async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> results = await db.query(
        'filter_cell_state',
        where: 'id = ?',
        whereArgs: [1],
      );

      if (results.isEmpty) {
        return {
          'showNNMuaBan': true,
          'showMoCua': false,
          'showGiaMuaBan3': true,
          'khoiLuong': 'rutGon',
        };
      }

      final row = results.first;
      return {
        'showNNMuaBan': row['show_nn_mua_ban'] == 1,
        'showMoCua': row['show_mo_cua'] == 1,
        'showGiaMuaBan3': row['show_gia_mua_ban_3'] == 1,
        'khoiLuong': row['khoi_luong'] as String,
      };
    } catch (e) {
      return null;
    }
  }
}

class MarketStateRepositoryImpl implements MarketStateRepository {
  final _dbHelper = getIt<DatabaseHelper>();

  @override
  Future<void> saveMarketState({
    String? selectedCategory,
    Map<String, List<String>>? filterMap,
    Map<String, String>? selectedSubItems,
  }) async {
    final db = await _dbHelper.database;
    await _ensureRowExists(db);

    final Map<String, dynamic> updateData = {};
    if (selectedCategory != null) {
      updateData['selected_category'] = selectedCategory;
    }
    if (filterMap != null) {
      updateData['filter_map'] = jsonEncode(filterMap);
    }
    if (selectedSubItems != null) {
      updateData['selected_sub_items'] = jsonEncode(selectedSubItems);
    }

    if (updateData.isNotEmpty) {
      await db.update(
        'market_state',
        updateData,
        where: 'id = ?',
        whereArgs: [1],
      );
    }
  }

  Future<void> _ensureRowExists(Database db) async {
    final existing = await db.query(
      'market_state',
      where: 'id = ?',
      whereArgs: [1],
    );

    if (existing.isEmpty) {
      await db.insert('market_state', {
        'id': 1,
        'selected_category': null,
        'filter_map': jsonEncode({}),
        'selected_sub_items': jsonEncode({}),
      },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  @override
  Future<void> clearMarketState() async {
    final db = await _dbHelper.database;
    await db.delete('market_state');
  }

  @override
  Future<Map<String, dynamic>?> loadMarketState() async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> results = await db.query(
        'market_state',
        where: 'id = ?',
        whereArgs: [1],
      );

      if (results.isEmpty) return null;

      final row = results.first;

      final filterMapJson = row['filter_map'] as String;
      final Map<String, dynamic> filterMapDynamic = filterMapJson.isNotEmpty ? jsonDecode(filterMapJson) : {};
      final Map<String, List<String>> filterMap = filterMapDynamic.map(
            (key, value) => MapEntry(key, List<String>.from(value)),
      );

      final selectedSubItemsJson = row['selected_sub_items'] as String;
      final Map<String, String> selectedSubItems = selectedSubItemsJson.isNotEmpty
          ? Map<String, String>.from(jsonDecode(selectedSubItemsJson))
          : {};

      return {
        'selectedCategory': row['selected_category'] as String?,
        'filterMap': filterMap,
        'selectedSubItems': selectedSubItems,
      };
    } catch (e) {
      return null;
    }
  }
}