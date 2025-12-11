abstract class NavigationRepository {
  Future<void> saveNavigationState({
    List<String?>? selectedSlots,
    int? selectedIndex,
  });

  Future<Map<String, dynamic>?> loadNavigationState();
  Future<void> clearNavigationState();
}