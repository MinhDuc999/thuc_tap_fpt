import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_state.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE catalog_state (
        id INTEGER PRIMARY KEY,
        selected_catalog TEXT,
        all_catalog TEXT NOT NULL,
        filter_catalog TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE filter_cell_state (
        id INTEGER PRIMARY KEY,
        show_nn_mua_ban INTEGER NOT NULL,
        show_mo_cua INTEGER NOT NULL,
        show_gia_mua_ban_3 INTEGER NOT NULL,
        khoi_luong TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE market_state (
        id INTEGER PRIMARY KEY,
        selected_category TEXT,
        filter_map TEXT NOT NULL,
        selected_sub_items TEXT NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}