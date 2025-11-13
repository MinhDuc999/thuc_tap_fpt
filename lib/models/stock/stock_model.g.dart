// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stock _$StockFromJson(Map<String, dynamic> json) => Stock(
      symbol: json['symbol'] as String,
      tc: (json['tc'] as num?)?.toDouble(),
      tran: (json['tran'] as num?)?.toDouble(),
      san: (json['san'] as num?)?.toDouble(),
      mua3: (json['mua3'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      mua2: (json['mua2'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      mua1: (json['mua1'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      khop: (json['khop'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      change: (json['change'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      ban1: (json['ban1'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      ban2: (json['ban2'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      ban3: (json['ban3'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      totalVolume: (json['totalVolume'] as num?)?.toDouble(),
      open: (json['open'] as num?)?.toDouble(),
      highLow: (json['highLow'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      mua: (json['mua'] as num?)?.toDouble(),
      ban: (json['ban'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$StockToJson(Stock instance) => <String, dynamic>{
      'symbol': instance.symbol,
      'tc': instance.tc,
      'tran': instance.tran,
      'san': instance.san,
      'mua3': instance.mua3,
      'mua2': instance.mua2,
      'mua1': instance.mua1,
      'khop': instance.khop,
      'change': instance.change,
      'ban1': instance.ban1,
      'ban2': instance.ban2,
      'ban3': instance.ban3,
      'totalVolume': instance.totalVolume,
      'open': instance.open,
      'highLow': instance.highLow,
      'mua': instance.mua,
      'ban': instance.ban,
    };
