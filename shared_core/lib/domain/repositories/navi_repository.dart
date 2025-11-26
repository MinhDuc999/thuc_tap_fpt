abstract class NavigationRepository{
  Future<void> saveState({
    required List<String?> selectedSlots,
    required List<String?> selected,
    required int selectedIndex,
    required int selectedTab,
  });
  Map<String,dynamic>? loadState();
  Future<void> clearState();
}