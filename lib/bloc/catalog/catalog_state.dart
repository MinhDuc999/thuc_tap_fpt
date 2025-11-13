import 'package:equatable/equatable.dart';

class CatalogState  extends Equatable{
  final bool isCatalogOpen;
  final String? selectedCatalog;
  final List<String> allCatalog;
  final Map<String, List<String>> filterCatalog;

  const CatalogState({
    this.isCatalogOpen = false,
    this.selectedCatalog,
    this.allCatalog = const [],
    this.filterCatalog = const {},
  });

  CatalogState copyWith({
    bool? isCatalogOpen,
    String? selectedCatalog,
    List<String>? allCatalog,
    bool clearSelectedCatalog = false,
    Map<String, List<String>>? filterCatalog,
  }) {
    return CatalogState(
      isCatalogOpen: isCatalogOpen ?? this.isCatalogOpen,
      selectedCatalog: clearSelectedCatalog
          ? null
          : (selectedCatalog ?? this.selectedCatalog),
      allCatalog: allCatalog ?? this.allCatalog,
      filterCatalog: filterCatalog ?? this.filterCatalog,
    );
  }

  @override
  List<Object?> get props => [isCatalogOpen,selectedCatalog,allCatalog,filterCatalog];
}