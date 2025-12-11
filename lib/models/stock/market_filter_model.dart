class MarketFilterItem {
  final int id;
  final String category;
  final List<String> stocks;

  const MarketFilterItem({
    required this.id,
    required this.category,
    required this.stocks,
  });

  MarketFilterItem copyWith({
    int? id,
    String? category,
    List<String>? stocks,
  }) {
    return MarketFilterItem(
      id: id ?? this.id,
      category: category ?? this.category,
      stocks: stocks ?? this.stocks,
    );
  }
}