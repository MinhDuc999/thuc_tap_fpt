class TabModel {
  final int id;
  final String key;
  final String displayName;
  final List<String> featureKeys;

  const TabModel({
    required this.id,
    required this.key,
    required this.displayName,
    required this.featureKeys,
  });
}