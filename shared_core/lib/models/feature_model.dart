class FeatureModel {
  final int id;
  final String key;
  final String displayName;
  final String iconPath;
  final bool isFixed;

  const FeatureModel({
    required this.id,
    required this.key,
    required this.displayName,
    required this.iconPath,
    this.isFixed = false,
  });
}