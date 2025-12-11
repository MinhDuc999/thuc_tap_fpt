import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_bang_gia/bloc/market/market_menu_event.dart';
import 'package:ui_bang_gia/bloc/market/market_menu_state.dart';
import 'package:ui_bang_gia/core/injection.dart';
import 'package:ui_bang_gia/domain/repository/price_board_repository.dart';
import 'package:ui_bang_gia/domain/usecase/market/market_usecase.dart';

class MarketMenuBloc extends Bloc<MarketMenuEvent, MarketMenuState> {
  final ToggleMarketMenuUseCase _toggleMarketMenuUseCase = getIt<ToggleMarketMenuUseCase>();
  final CloseMarketMenuUseCase _closeMarketMenuUseCase = getIt<CloseMarketMenuUseCase>();
  final ClearMarketSelectUseCase _clearMarketSelectUseCase = getIt<ClearMarketSelectUseCase>();
  final SelectMarketCategoryUseCase _selectMarketCategoryUseCase = getIt<SelectMarketCategoryUseCase>();
  final SelectSubMenuItemUseCase _selectSubMenuItemUseCase = getIt<SelectSubMenuItemUseCase>();

  MarketMenuBloc() : super(MarketMenuState()) {
    on<ToggleMarketMenuEvent>(_onToggleMarketMenu);
    on<CloseMarketMenuEvent>(_onCloseMarketMenu);
    on<SelectMarketCategoryEvent>(_onSelectMarketCategory);
    on<SelectSubMenuItemEvent>(_onSelectSubMenuItem);
    on<ClearMarketSelectionEvent>(_onClearMarketSelection);
    on<InitializeMarketMenuEvent>(_onInitialize);

    add(InitializeMarketMenuEvent());
  }

  Future<void> _onInitialize(InitializeMarketMenuEvent event, Emitter<MarketMenuState> emit) async {
    final repository = getIt<MarketStateRepository>();
    final catalogRepo = getIt<CatalogRepository>();

    final catalogState = await catalogRepo.loadCatalogState();
    if (catalogState != null && catalogState['selectedCatalog'] != null) {
      emit(MarketMenuState(
        isMenuOpen: false,
        selectedCategory: null,
        selectedParent: null,
        selectedSubItems: {},
      ));
      return;
    }

    final savedState = await repository.loadMarketState();
    if (savedState != null && savedState['selectedCategory'] != null) {
      emit(MarketMenuState(
        isMenuOpen: false,
        selectedCategory: savedState['selectedCategory'],
        selectedParent: null,
        selectedSubItems: savedState['selectedSubItems'],
      ));
      return;
    }

    emit(MarketMenuState(
      isMenuOpen: false,
      selectedCategory: 'HOSE',
      selectedParent: null,
      selectedSubItems: {'HOSE': 'HOSE'},
    ));
  }

  void _onToggleMarketMenu(ToggleMarketMenuEvent event, Emitter<MarketMenuState> emit) {
    final newIsOpen = _toggleMarketMenuUseCase.execute(state.isMenuOpen);
    emit(state.copyWith(isMenuOpen: newIsOpen, selectedParent: null,));
  }

  void _onCloseMarketMenu(CloseMarketMenuEvent event, Emitter<MarketMenuState> emit) {
    final newIsClose = _closeMarketMenuUseCase.execute();
    emit(state.copyWith(isMenuOpen:newIsClose,selectedParent: null));
  }

  Future<void> _onClearMarketSelection(ClearMarketSelectionEvent event, Emitter<MarketMenuState> emit) async {
    await _clearMarketSelectUseCase.execute();
    emit(state.copyWith(clearSelectedCategory: true, clearSelectedParent: true, selectedSubItems: {},));
  }

  Future<void> _onSelectMarketCategory(
      SelectMarketCategoryEvent event,
      Emitter<MarketMenuState> emit,
      ) async {
    final params = SelectMarketCategoryParams(
      category: event.category,
      hasSubmenu: event.hasSubmenu,
      currentSelectedCategory: state.selectedCategory,
      currentSelectedSubItems: state.selectedSubItems,
    );

    final result = await _selectMarketCategoryUseCase.execute(params);

    emit(state.copyWith(
      selectedCategory: result['selectedCategory'],
      selectedParent: result['selectedParent'],
      selectedSubItems: result['selectedSubItems'],
    ));
  }

  Future<void> _onSelectSubMenuItem(
      SelectSubMenuItemEvent event,
      Emitter<MarketMenuState> emit,
      ) async {
    final result = await _selectSubMenuItemUseCase.execute(
      event.subItem,
      state.selectedParent,
    );

    emit(state.copyWith(
      selectedCategory: result['selectedCategory'],
      selectedParent: result['selectedParent'],
      selectedSubItems: result['selectedSubItems'],
    ));
  }
}
