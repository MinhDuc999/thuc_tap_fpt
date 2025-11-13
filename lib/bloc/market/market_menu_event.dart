import 'package:equatable/equatable.dart';

abstract class MarketMenuEvent  extends Equatable{}

class ToggleMarketMenuEvent extends MarketMenuEvent {
  @override
  List<Object?> get props => [];
}

class CloseMarketMenuEvent extends MarketMenuEvent {
  @override
  List<Object?> get props => [];
}

class ClearMarketSelectionEvent extends MarketMenuEvent {
  @override
  List<Object?> get props => [];
}

class SelectMarketCategoryEvent extends MarketMenuEvent {
  final String category;
  final bool hasSubmenu;

  SelectMarketCategoryEvent(this.category, this.hasSubmenu);

  @override
  List<Object?> get props => [category,hasSubmenu];
}

class SelectSubMenuItemEvent extends MarketMenuEvent {
  final String subItem;
  SelectSubMenuItemEvent(this.subItem);
  @override
  List<Object?> get props => [subItem];
}