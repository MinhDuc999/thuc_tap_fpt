import 'package:equatable/equatable.dart';

class MarketMenuState extends Equatable{
  final bool isMenuOpen;
  final String? selectedCategory;
  final String? selectedParent;
  final Map<String, String> selectedSubItems;

  const MarketMenuState({
    this.isMenuOpen = false,
    this.selectedCategory,
    this.selectedParent,
    this.selectedSubItems = const {},
  });

  MarketMenuState copyWith({
    bool? isMenuOpen,
    String? selectedCategory,
    String? selectedParent,
    Map<String, String>? selectedSubItems,
    bool clearSelectedCategory = false,
    bool clearSelectedParent = false,
  }) {
    return MarketMenuState(
      isMenuOpen: isMenuOpen ?? this.isMenuOpen,
      selectedCategory: clearSelectedCategory ? null : (selectedCategory ?? this.selectedCategory),
      selectedParent: clearSelectedParent ? null : (selectedParent ?? this.selectedParent),
      selectedSubItems: selectedSubItems ?? this.selectedSubItems,
    );
  }
  @override
  List<Object?> get props => [isMenuOpen,selectedCategory,selectedParent,selectedSubItems];
}