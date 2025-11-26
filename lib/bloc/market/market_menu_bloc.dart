import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_bang_gia/bloc/market/market_menu_event.dart';
import 'package:ui_bang_gia/bloc/market/market_menu_state.dart';
import 'package:ui_bang_gia/core/injection.dart';
import 'package:ui_bang_gia/domain/repository/catalogRepository.dart';
import 'package:ui_bang_gia/domain/repository/marketMenuRepository.dart';
import 'package:ui_bang_gia/domain/usecase/market/clear_market_select_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/market/close_market_menu_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/market/select_market_category_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/market/select_submenu_item_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/market/toggle_market_menu_usecase.dart';

class MarketMenuBloc extends Bloc<MarketMenuEvent, MarketMenuState> {
  final ToggleMarketMenuUseCase _toggleMarketMenuUseCase = getIt<ToggleMarketMenuUseCase>();
  final CloseMarketMenuUseCase _closeMarketMenuUseCase = getIt<CloseMarketMenuUseCase>();
  final ClearMarketSelectUseCase _clearMarketSelectUseCase = getIt<ClearMarketSelectUseCase>();
  final SelectMarketCategoryUseCase _selectMarketCategoryUseCase = getIt<SelectMarketCategoryUseCase>();
  final SelectSubMenuItemUseCase _selectSubMenuItemUseCase = getIt<SelectSubMenuItemUseCase>();


  MarketMenuBloc() : super(_loadInitialState()) {
    on<ToggleMarketMenuEvent>(_onToggleMarketMenu);
    on<CloseMarketMenuEvent>(_onCloseMarketMenu);
    on<SelectMarketCategoryEvent>(_onSelectMarketCategory);
    on<SelectSubMenuItemEvent>(_onSelectSubMenuItem);
    on<ClearMarketSelectionEvent>(_onClearMarketSelection);
  }

  static MarketMenuState _loadInitialState() {
    final repository = getIt<MarketMenuRepository>();
    final catalogRepo = getIt<CatalogRepository>();

    final catalogState = catalogRepo.loadCatalogState();
    if (catalogState != null && catalogState['selectedCatalog'] != null) {
      return MarketMenuState(
        isMenuOpen: false,
        selectedCategory: null,
        selectedParent: null,
        selectedSubItems: {},
      );
    }

    final savedState = repository.loadMarketMenuState();
    if (savedState != null && savedState['selectedCategory'] != null) {
      return MarketMenuState(
        isMenuOpen: false,
        selectedCategory: savedState['selectedCategory'],
        selectedParent: savedState['selectedParent'],
        selectedSubItems: savedState['selectedSubItems'],
      );
    }

    return MarketMenuState(
      isMenuOpen: false,
      selectedCategory: 'HOSE',
      selectedParent: 'HOSE',
      selectedSubItems: {'HOSE': 'HOSE'},
    );
  }

  void _onToggleMarketMenu(ToggleMarketMenuEvent event, Emitter<MarketMenuState> emit) {
    emit(_toggleMarketMenuUseCase.execute(state));
  }

  void _onCloseMarketMenu(CloseMarketMenuEvent event, Emitter<MarketMenuState> emit) {
    emit(_closeMarketMenuUseCase.execute(state));
  }

  void _onClearMarketSelection(ClearMarketSelectionEvent event, Emitter<MarketMenuState> emit) {
    emit(_clearMarketSelectUseCase.execute(state));
  }

  void _onSelectMarketCategory(SelectMarketCategoryEvent event, Emitter<MarketMenuState> emit) {
    emit(_selectMarketCategoryUseCase.execute(
      currentState: state,
      category: event.category,
      hasSubmenu: event.hasSubmenu,
    ));
  }

  void _onSelectSubMenuItem(SelectSubMenuItemEvent event, Emitter<MarketMenuState> emit) {
    emit(_selectSubMenuItemUseCase.execute(
      currentState: state,
      subItem: event.subItem,
    ));
  }
}
