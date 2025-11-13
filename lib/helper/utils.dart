import 'package:flutter/material.dart';
import 'package:ui_bang_gia/models/stock/stock_model.dart';

Color getChangeColor(String? valueStr) {
  final value = double.tryParse(valueStr?.replaceAll('%', '').replaceAll('+', '') ?? '0') ?? 0;
  if (value == 0) return const Color(0xFFFF9F41);
  if (value > 0) return const Color(0xFF1AAF74);
  return const Color(0xFFF34859);
}

String fmtValue(dynamic v) {
  if (v == null) return ' ';

  if (v is List && v.isNotEmpty) {
    final first = v[0];
    final second = v.length > 1 ? v[1] : null;

    String fmt(dynamic x) {
      if (x == null) return ' ';
      return formatNumber(x);
    }

    if (first == null && second != null) {
      return '\n${fmt(second)}';
    } else if (first != null && second == null) {
      return '${fmt(first)}\n ';
    } else if (first != null && second != null) {
      return '${fmt(first)}\n${fmt(second)}';
    } else {
      return ' ';
    }
  }

  if (v is num) return formatNumber(v);

  return v.toString();
}

String formatNumber(num v) {
  if (v >= 1000) {
    String full = v.toInt().toString();
    if (full.length <= 3) return full;

    int len = full.length;
    String result = '${full.substring(0, len - 3)},${full.substring(len - 3, len - 2)}';
    return result.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},'
    );
  }

  if (v == v.toInt()) return v.toInt().toString();

  String s = v.toStringAsFixed(2);
  if (s.endsWith('0')) s = s.substring(0, s.length - 1);
  if (s.endsWith('.')) s = s.substring(0, s.length - 1);
  return s.replaceAll(',', '.');
}

Color getColorKhop(double? val, Stock stock) {
  double? tc = stock.tc;
  if (tc == null || val == null) return Color(0xFFFF9F41);
  if (val < tc) return Color(0xFFF34859);
  if (val > tc) return Color(0xFF1AAF74);
  return Color(0xFFFF9F41);
}

Color getCellColor(int index, String value, Stock stock) {
  if (index == 0) {
    return Color(0xFF111315);
  }
  if (index == 1) {
    return Color(0xFFFF9F41);
  }
  if (index == 11) {
    return Color(0xFFEFEFEF);
  }
  if (index == 14) {
    return Color(0xFFEFEFEF);
  }

  double? tc = stock.tc;
  double? cellValue = getFirstValue(value);
  double? tran= stock.tran;
  double? san = stock.san;

  if (tc == null || cellValue == null) return Color(0xFFEFEFEF);
  if (index == 7) {
    if (cellValue > 0 && cellValue == tran) return Color(0xFFA43EE7);
    if (cellValue > 0 && cellValue == san) return Color(0xFF3FC2EB);
    if (cellValue > 0) return Color(0xFF1AAF74);

    if (cellValue < 0 && cellValue == tran) return Color(0xFFA43EE7);
    if (cellValue < 0 && cellValue == san) return Color(0xFF3FC2EB);
    if (cellValue < 0) return Color(0xFFF34859);

    if (cellValue == 0 && cellValue == tran) return Color(0xFFA43EE7);
    if (cellValue == 0 && cellValue == san) return Color(0xFF3FC2EB);
    if(cellValue==0) return Color(0xFFFF9F41);
  }
  if (cellValue < tc && cellValue == tran) return Color(0xFFA43EE7);
  if (cellValue < tc && cellValue == san) return Color(0xFF3FC2EB);
  if (cellValue < tc) return Color(0xFFF34859);

  if(cellValue > tc && cellValue == tran) return Color(0xFFA43EE7);
  if(cellValue > tc && cellValue == san) return Color(0xFF3FC2EB);
  if (cellValue > tc) return Color(0xFF1AAF74);

  if (cellValue == tc && cellValue == tran) return Color(0xFFA43EE7);
  if (cellValue == tc && cellValue == san) return Color(0xFF3FC2EB);
  return Color(0xFFFF9F41);
}

double? getFirstValue(String value) {
  final parts = value.split('\n');
  if (parts.isEmpty) return null;
  final firstParts = parts[0].trim();
  if (firstParts.isEmpty || firstParts == ' ') return null;
  final v = firstParts.replaceAll(',', '.');
  return double.tryParse(v);
}


String formatVolume(dynamic v, String volumeType) {
  if (v == null) return ' ';
  if (v is! num) {
    final parsed = double.tryParse(v.toString());
    if (parsed == null) return ' ';
    v = parsed;
  }
  if (volumeType == 'dayDu') {
    return v.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},'
    );
  } else {
    String full = v.toInt().toString();
    if (full.length <= 3) return full;

    int len = full.length;
    String result = '${full.substring(0, len - 3)},${full.substring(len - 3, len - 2)}';
    return result.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},'
    );
  }
}

Color getFlashColorForCell(Stock s,int originalIndex){
  String value = '';
  switch(originalIndex){
    case 3:
      value = fmtValue(s.mua3);
      break;
    case 4:
      value = fmtValue(s.mua2);
      break;
    case 5:
      value = fmtValue(s.mua1);
      break;
    case 6:
      value = fmtValue(s.khop);
      break;
    case 7:
      value = fmtValue(s.change);
      break;
    case 8:
      value = fmtValue(s.ban1);
      break;
    case 9:
      value = fmtValue(s.ban2);
      break;
    case 10:
      value = fmtValue(s.ban3);
      break;
    case 12:
      value = fmtValue(s.open);
      break;
    case 13:
      value = fmtValue(s.highLow);
      break;
  }
  return getCellColor(originalIndex, value, s);
}


bool cellHasValue(Stock s, int originalIndex) {
  dynamic value;
  switch (originalIndex) {
    case 3: value = s.mua3; break;
    case 4: value = s.mua2; break;
    case 5: value = s.mua1; break;
    case 6: value = s.khop; break;
    case 7: value = s.change; break;
    case 8: value = s.ban1; break;
    case 9: value = s.ban2; break;
    case 10: value = s.ban3; break;
    case 11: value = s.totalVolume; break;
    case 12: value = s.open; break;
    case 13: value = s.highLow; break;
    case 14:
      return (s.mua != null) || (s.ban != null );
    default: return false;
  }

  if (value == null) return false;
  if (value is List) {
    return value.isNotEmpty && value.any((v) => v != null);
  }
  if(value is num) return true;
  return false;
}

