import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_bang_gia/bloc/catalog/catalog_event.dart';
import 'package:ui_bang_gia/bloc/catalog/catalog_state.dart';
import 'package:ui_bang_gia/core/injection.dart';
import 'package:ui_bang_gia/domain/usecase/catalog/catalog_usecase.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final ToggleCatalogUseCase _toggleCatalogUseCase = getIt<ToggleCatalogUseCase>();
  final CloseCatalogUseCase _closeCatalogUseCase = getIt<CloseCatalogUseCase>();
  final ClearCatalogUseCase _clearCatalogUseCase = getIt<ClearCatalogUseCase>();
  final SelectCatalogUseCase _selectCatalogUseCase = getIt<SelectCatalogUseCase>();
  final AddCatalogUseCase _addCatalogUseCase = getIt<AddCatalogUseCase>();
  final RenameCatalogUseCase _renameCatalogUseCase = getIt<RenameCatalogUseCase>();
  final DeleteCatalogUseCase _deleteCatalogUseCase = getIt<DeleteCatalogUseCase>();
  final AddStockToCatalogUseCase _addStockToCatalogUseCase = getIt<AddStockToCatalogUseCase>();
  final DeleteStockFromCatalogUseCase _deleteStockFromCatalogEvent = getIt<DeleteStockFromCatalogUseCase>();
  final LoadCatalogStateUseCase _loadCatalogStateUseCase = getIt<LoadCatalogStateUseCase>();


  final TextEditingController addCatalog = TextEditingController();
  final TextEditingController updateCatalog = TextEditingController();

  CatalogBloc() : super(CatalogState()) {
    on<ToggleCatalogEvent>(_onToggleCatalog);
    on<CloseCatalogEvent>(_onCloseCatalog);
    on<SelectCatalogEvent>(_onSelectCatalog);
    on<AddCatalogEvent>(_onAddCatalog);
    on<RenameCatalogEvent>(_onRenameCatalog);
    on<DeleteCatalogEvent>(_onDeleteCatalog);
    on<ClearCatalogSelectionEvent>(_onClearCatalogSelection);
    on<AddStockToCatalogEvent>(_onAddStockToCatalog);
    on<DeleteStockFromCatalogEvent>(_onDeleteStockFromCatalog);
    on<InitializeCatalogEvent>(_onInitialize);

    add(InitializeCatalogEvent());
  }

  Future<void> _onInitialize(InitializeCatalogEvent event, Emitter<CatalogState> emit) async {
    final savedState = await _loadCatalogStateUseCase.execute();

    if (savedState != null) {
      emit(CatalogState(
        isCatalogOpen: false,
        selectedCatalog: savedState['selectedCatalog'],
        allCatalog: savedState['allCatalog'],
        filterCatalog: savedState['filterCatalog'],
      ));
    }
  }

  void _onToggleCatalog(ToggleCatalogEvent event, Emitter<CatalogState> emit) {
    final newState = _toggleCatalogUseCase.execute(state.isCatalogOpen);
    emit(state.copyWith(isCatalogOpen: newState));
  }

  void _onCloseCatalog(CloseCatalogEvent event, Emitter<CatalogState> emit) {
    final newState = _closeCatalogUseCase.execute();
    emit(state.copyWith(isCatalogOpen: newState));
  }

  Future<void> _onClearCatalogSelection(ClearCatalogSelectionEvent event, Emitter<CatalogState> emit) async {
    await _clearCatalogUseCase.execute();
    emit(state.copyWith(clearSelectedCatalog: true));
  }

  Future<void> _onSelectCatalog(SelectCatalogEvent event, Emitter<CatalogState> emit,) async {
    final newCategory = await _selectCatalogUseCase.execute(event.category);
    emit(state.copyWith(selectedCatalog: newCategory));
  }

  Future<void> _onAddCatalog(AddCatalogEvent event, Emitter<CatalogState> emit) async {
    final result = await _addCatalogUseCase.execute(state.allCatalog, event.name);
    if (result != null) {
      emit(state.copyWith(allCatalog: result));
    }
  }

  Future<void> _onRenameCatalog(RenameCatalogEvent event, Emitter<CatalogState> emit) async {
    final newName = updateCatalog.text.trim();
    if (newName.isEmpty) return;

    final params = RenameCatalogParams(
      currentCatalogs: state.allCatalog,
      currentFilterCatalog: state.filterCatalog,
      oldName: event.oldName,
      newName: event.newName,
    );

    final result = await _renameCatalogUseCase.execute(params);

    if (result != null) {
      emit(state.copyWith(
        allCatalog: result['allCatalog'],
        selectedCatalog: result['selectedCatalog'],
        filterCatalog: result['filterCatalog'],
      ));
    }
    updateCatalog.clear();
  }

  Future<void> _onDeleteCatalog(DeleteCatalogEvent event, Emitter<CatalogState> emit) async {
    final params = DeleteCatalogParams(
        currentCatalogs: state.allCatalog,
        currentFilterCatalog: state.filterCatalog,
        name: event.name
    );
    final newCatalogs = await _deleteCatalogUseCase.execute(params);
    emit(state.copyWith(
      allCatalog: newCatalogs['allCatalog'],
      filterCatalog: newCatalogs['filterCatalog'],
    ));
  }

  Future<void> _onAddStockToCatalog(AddStockToCatalogEvent event, Emitter<CatalogState> emit) async {
    final result = await _addStockToCatalogUseCase.execute(
      state.filterCatalog,
      event.catalogName,
      event.stockSymbol,
    );

    if (result != null) {
      emit(state.copyWith(filterCatalog: result));
    }
  }

  Future<void> _onDeleteStockFromCatalog(DeleteStockFromCatalogEvent event, Emitter<CatalogState> emit) async {
    final newFilterCatalog = await _deleteStockFromCatalogEvent.execute(
      state.filterCatalog,
      event.catalogName,
      event.stockSymbol,
    );
    emit(state.copyWith(filterCatalog: newFilterCatalog));
  }

  void addCatalogRequest() {
    final name = addCatalog.text.trim();
    add(AddCatalogEvent(name));
    addCatalog.clear();
  }

  @override
  Future<void> close() {
    addCatalog.dispose();
    updateCatalog.dispose();
    return super.close();
  }
}