class MarketCategory {
  final int id;
  final String name;
  final List<String> sub;

  const MarketCategory({
    required this.id,
    required this.name,
    required this.sub,
  });

  MarketCategory copyWith({
    int? id,
    String? name,
    List<String>? sub,
  }) {
    return MarketCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      sub: sub ?? this.sub,
    );
  }
}

