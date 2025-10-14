class NavigationState {
  final List<String?> selectedSlots;
  final List<String?> selected;
  final int selectedIndex;
  final int selectedTab;

  NavigationState(
      {required this.selectedSlots, required this.selected, required this.selectedIndex, required this.selectedTab});

  NavigationState copyWith({
    List<String?>? selectedSlots,
    List<String?>? selected,
    int? selectedIndex,
    int? selectedTab,
  }) {
    return NavigationState(
        selectedSlots: selectedSlots ?? this.selectedSlots,
        selected: selected ?? this.selected,
        selectedIndex: selectedIndex ?? this.selectedIndex,
        selectedTab: selectedTab ?? this.selectedTab
    );
  }

  bool get hasEnoughSelected =>
      selectedSlots
          .where((e) => e != null)
          .length >= 5;

}