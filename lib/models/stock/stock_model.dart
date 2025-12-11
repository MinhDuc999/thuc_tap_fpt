class Stock {
  final String symbol;
  final double? tc;
  final double? tran;
  final double? san;
  final List<double>? mua3;
  final List<double>? mua2;
  final List<double>? mua1;
  final List<double>? khop;
  final List<double>? change;
  final List<double>? ban1;
  final List<double>? ban2;
  final List<double>? ban3;
  final double? totalVolume;
  final double? open;
  final List<double>? highLow;
  final double? mua;
  final double? ban;

  Stock({
    required this.symbol,
    required this.tc,
    required this.tran,
    required this.san,
    required this.mua3,
    required this.mua2,
    required this.mua1,
    required this.khop,
    required this.change,
    required this.ban1,
    required this.ban2,
    required this.ban3,
    required this.totalVolume,
    required this.open,
    required this.highLow,
    required this.mua,
    required this.ban,
  });


  Stock copyWith({
    String? symbol,
    double? tc,
    double? tran,
    double? san,
    List<double>? mua3,
    List<double>? mua2,
    List<double>? mua1,
    List<double>? khop,
    List<double>? change,
    List<double>? ban1,
    List<double>? ban2,
    List<double>? ban3,
    double? totalVolume,
    double? open,
    List<double>? highLow,
    double? mua,
    double? ban,
  }) {
    return Stock(
      symbol: symbol ?? this.symbol,
      tc: tc ?? this.tc,
      tran: tran ?? this.tran,
      san: san ?? this.san,
      mua3: mua3 ?? this.mua3,
      mua2: mua2 ?? this.mua2,
      mua1: mua1 ?? this.mua1,
      khop: khop ?? this.khop,
      change: change ?? this.change,
      ban1: ban1 ?? this.ban1,
      ban2: ban2 ?? this.ban2,
      ban3: ban3 ?? this.ban3,
      totalVolume: totalVolume ?? this.totalVolume,
      open: open ?? this.open,
      highLow: highLow ?? this.highLow,
      mua: mua ?? this.mua,
      ban: ban ?? this.ban,
    );
  }
}
