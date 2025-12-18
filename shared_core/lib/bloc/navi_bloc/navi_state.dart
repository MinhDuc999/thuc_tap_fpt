import 'package:equatable/equatable.dart';
import 'package:shared_core/models/feature_model.dart';

class NavigationState extends Equatable{
  final bool isSearchViewOpen;
  final List<String?> selectedSlots;
  final List<FeatureModel>? searchResults;
  final String? searchQuery;
  final List<String>? recentlyRemovedFeature;
  final List<String?> selected;
  final int selectedIndex;
  final int selectedTab;

  const NavigationState(
      {this.isSearchViewOpen =false,required this.selectedSlots, required this.selected, required this.selectedIndex, required this.selectedTab,this.recentlyRemovedFeature, this.searchResults, this.searchQuery});

  NavigationState copyWith({
    bool? isSearchViewOpen,
    List<String?>? selectedSlots,
    List<String?>? selected,
    List<FeatureModel>? searchResults,
    String? searchQuery,
    List<String>? recentlyRemovedFeature,
    int? selectedIndex,
    int? selectedTab,
  }) {
    return NavigationState(
      isSearchViewOpen: isSearchViewOpen ?? this.isSearchViewOpen,
      selectedSlots: selectedSlots ?? this.selectedSlots,
      selected: selected ?? this.selected,
      searchResults: searchResults ?? this.searchResults,
      searchQuery: searchQuery ?? this.searchQuery,
      recentlyRemovedFeature: recentlyRemovedFeature,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      selectedTab: selectedTab ?? this.selectedTab
    );
  }

  bool get hasEnoughSelected => selectedSlots.where((e) => e != null).length >= 5;

  @override
  List<Object?> get props => [isSearchViewOpen,selectedSlots,selectedIndex,selected,selectedTab,searchResults,searchQuery,recentlyRemovedFeature];

}