import 'package:equatable/equatable.dart';

abstract class CatalogEvent extends Equatable{}

class ToggleCatalogEvent extends CatalogEvent {
  @override
  List<Object?> get props => [];
}

class CloseCatalogEvent extends CatalogEvent {
  @override
  List<Object?> get props => [];
}

class InitializeCatalogEvent extends CatalogEvent {
  @override
  List<Object?> get props => [];
}

class ClearCatalogSelectionEvent extends CatalogEvent {
  @override
  List<Object?> get props => [];
}

class SelectCatalogEvent extends CatalogEvent {
  final String category;
  SelectCatalogEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class AddCatalogEvent extends CatalogEvent {
  final String name;
  AddCatalogEvent(this.name);

  @override
  List<Object?> get props => [name];
}

class RenameCatalogEvent extends CatalogEvent {
  final String oldName;
  final String newName;
  RenameCatalogEvent(this.oldName, this.newName);

  @override
  List<Object?> get props => [oldName,newName];
}

class DeleteCatalogEvent extends CatalogEvent {
  final String name;
  DeleteCatalogEvent(this.name);

  @override
  List<Object?> get props => [name];
}

class AddStockToCatalogEvent extends CatalogEvent {
  final String catalogName;
  final String stockSymbol;

  AddStockToCatalogEvent(this.catalogName, this.stockSymbol);

  @override
  List<Object?> get props => [catalogName,stockSymbol];
}

class DeleteStockFromCatalogEvent extends CatalogEvent {
  final String catalogName;
  final String stockSymbol;

  DeleteStockFromCatalogEvent(this.catalogName, this.stockSymbol);

  @override
  List<Object?> get props => [catalogName,stockSymbol];
}