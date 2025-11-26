import 'package:shared_core/core/injection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_bang_gia/domain/repository/filterCellRepository.dart';

class FilterCellRepositoryImpl implements FilterCellRepository{
  static const String _keyShowNNMuaBan = 'show_nn_mua_ban';
  static const String _keyShowMoCua = 'show_mo_cua';
  static const String _keyShowGiaMuaBan3 = 'show_gia_mua_ban_3';
  static const String _keyKhoiLuong = 'khoi_luong';
  final _prefs = getIt<SharedPreferences>();

  @override
  Future<void> clearFilterCellState() async{
    await _prefs.remove(_keyShowNNMuaBan);
    await _prefs.remove(_keyShowMoCua);
    await _prefs.remove(_keyShowGiaMuaBan3);
    await _prefs.remove(_keyKhoiLuong);
  }

  @override
  Map<String, dynamic>? loadFilterCellState() {
    try {
      final showNNMuaBan = _prefs.getBool(_keyShowNNMuaBan);
      final showMoCua = _prefs.getBool(_keyShowMoCua);
      final showGiaMuaBan3 = _prefs.getBool(_keyShowGiaMuaBan3);
      final khoiLuong = _prefs.getString(_keyKhoiLuong);

      //if (showNNMuaBan == null) return null;

      return {
        'showNNMuaBan': showNNMuaBan ?? true,
        'showMoCua': showMoCua ?? false,
        'showGiaMuaBan3': showGiaMuaBan3 ?? true,
        'khoiLuong': khoiLuong ?? 'rutGon',
      };
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveFilterCellState({required bool showNNMuaBan, required bool showMoCua, required bool showGiaMuaBan3, required String khoiLuong}) async {
    await _prefs.setBool(_keyShowNNMuaBan, showNNMuaBan);
    await _prefs.setBool(_keyShowMoCua, showMoCua);
    await _prefs.setBool(_keyShowGiaMuaBan3, showGiaMuaBan3);
    await _prefs.setString(_keyKhoiLuong, khoiLuong);
  }

}