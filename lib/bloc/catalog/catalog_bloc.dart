import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_bang_gia/bloc/catalog/catalog_event.dart';
import 'package:ui_bang_gia/bloc/catalog/catalog_state.dart';
import 'package:ui_bang_gia/core/injection.dart';
import 'package:ui_bang_gia/domain/usecase/catalog/add_stock_to_catalog_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/catalog/clear_catalog_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/catalog/delete_stock_from_catalog_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/catalog/load_catalog_use_case.dart';
import 'package:ui_bang_gia/domain/usecase/catalog/toggle_catalog_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/catalog/close_catalog_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/catalog/select_catalog_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/catalog/add_catalog_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/catalog/rename_catalog_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/catalog/delete_catalog_usecase.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final ToggleCatalogUseCase _toggleCatalogUseCase = getIt<ToggleCatalogUseCase>();
  final CloseCatalogUseCase _closeCatalogUseCase = getIt<CloseCatalogUseCase>();
  final ClearCatalogUseCase _clearCatalogUseCase = getIt<ClearCatalogUseCase>();
  final SelectCatalogUseCase _selectCatalogUseCase = getIt<SelectCatalogUseCase>();
  final LoadCatalogUseCase _loadCatalogUseCase = getIt<LoadCatalogUseCase>();
  final AddCatalogUseCase _addCatalogUseCase = getIt<AddCatalogUseCase>();
  final RenameCatalogUseCase _renameCatalogUseCase = getIt<RenameCatalogUseCase>();
  final DeleteCatalogUseCase _deleteCatalogUseCase = getIt<DeleteCatalogUseCase>();
  final AddStockToCatalogUseCase _addStockToCatalogUseCase = getIt<AddStockToCatalogUseCase>();
  final DeleteStockFromCatalogUseCase _deleteStockFromCatalogEvent = getIt<DeleteStockFromCatalogUseCase>();

  final TextEditingController addCatalog = TextEditingController();
  final TextEditingController updateCatalog = TextEditingController();

  CatalogBloc() : super(CatalogState()) {
    on<ToggleCatalogEvent>(_onToggleCatalog);
    on<CloseCatalogEvent>(_onCloseCatalog);
    on<SelectCatalogEvent>(_onSelectCatalog);
    on<LoadCatalogEvent>(_onLoadCatalog);
    on<AddCatalogEvent>(_onAddCatalog);
    on<RenameCatalogEvent>(_onRenameCatalog);
    on<DeleteCatalogEvent>(_onDeleteCatalog);
    on<ClearCatalogSelectionEvent>(_onClearCatalogSelection);
    on<AddStockToCatalogEvent>(_onAddStockToCatalog);
    on<DeleteStockFromCatalogEvent>(_onDeleteStockFromCatalog);
  }

  void _onToggleCatalog(ToggleCatalogEvent event, Emitter<CatalogState> emit) {
    emit(_toggleCatalogUseCase.execute(state));
  }

  void _onCloseCatalog(CloseCatalogEvent event, Emitter<CatalogState> emit) {
    emit(_closeCatalogUseCase.execute(state));
  }

  void _onClearCatalogSelection(ClearCatalogSelectionEvent event, Emitter<CatalogState> emit) {
    emit(_clearCatalogUseCase.execute(state));
  }

  void _onSelectCatalog(SelectCatalogEvent event, Emitter<CatalogState> emit) {
    emit(_selectCatalogUseCase.execute(state, event.category));
  }

  void _onLoadCatalog(LoadCatalogEvent event, Emitter<CatalogState> emit) {
    emit(_loadCatalogUseCase.execute(state, event.catalogs));
  }

  void _onAddCatalog(AddCatalogEvent event, Emitter<CatalogState> emit) {
    emit(_addCatalogUseCase.execute(state, event.name));
  }

  void _onRenameCatalog(RenameCatalogEvent event, Emitter<CatalogState> emit) {
    final newName = updateCatalog.text.trim();
    if (newName.isEmpty) return;
    emit(_renameCatalogUseCase.execute(state, event.oldName, event.newName));
    updateCatalog.clear();
  }

  void _onDeleteCatalog(DeleteCatalogEvent event, Emitter<CatalogState> emit) {
    emit(_deleteCatalogUseCase.execute(state, event.name));
  }

  void _onAddStockToCatalog(AddStockToCatalogEvent event, Emitter<CatalogState> emit) {
    final previousState = state;
    final newState = _addStockToCatalogUseCase.execute(state, event.catalogName, event.stockSymbol);
    if (newState != previousState) {
      emit(newState);
    }
  }

  void _onDeleteStockFromCatalog(DeleteStockFromCatalogEvent event, Emitter<CatalogState> emit){
    emit(_deleteStockFromCatalogEvent.execute(state,event.catalogName, event.stockSymbol));
  }


  void addCatalogRequest(){
    final name = addCatalog.text.trim();
    add(AddCatalogEvent(name));
    addCatalog.clear();
  }

  @override
  Future<void> close() {
    addCatalog.dispose();
    return super.close();
  }
}