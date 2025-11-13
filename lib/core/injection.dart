import 'package:get_it/get_it.dart';
import 'package:ui_bang_gia/domain/usecase/catalog/add_catalog_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/catalog/add_stock_to_catalog_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/catalog/clear_catalog_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/catalog/close_catalog_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/catalog/delete_catalog_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/catalog/delete_stock_from_catalog_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/catalog/load_catalog_use_case.dart';
import 'package:ui_bang_gia/domain/usecase/catalog/rename_catalog_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/catalog/select_catalog_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/catalog/toggle_catalog_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/market/clear_market_select_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/market/close_market_menu_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/market/filter_market_by_category_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/market/get_display_stocks_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/market/load_market_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/market/select_market_category_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/market/select_submenu_item_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/market/sort_market_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/market/toggle_market_menu_usecase.dart';
final getIt = GetIt.instance;

Future<void> init() async{
  getIt.registerLazySingleton<ToggleMarketMenuUseCase>(() => ToggleMarketMenuUseCase());
  getIt.registerLazySingleton<CloseMarketMenuUseCase>(() => CloseMarketMenuUseCase());
  getIt.registerLazySingleton<SelectSubMenuItemUseCase>(() => SelectSubMenuItemUseCase());
  getIt.registerLazySingleton<SelectMarketCategoryUseCase>(() => SelectMarketCategoryUseCase());
  getIt.registerLazySingleton<ClearMarketSelectUseCase>(() => ClearMarketSelectUseCase());

  getIt.registerLazySingleton<LoadMarketUseCase>(() => LoadMarketUseCase());
  getIt.registerLazySingleton<SortMarketUseCase>(() => SortMarketUseCase());
  getIt.registerLazySingleton<FilterMarketByCategoryUseCase>(() => FilterMarketByCategoryUseCase());
  getIt.registerLazySingleton<GetDisplayStocksUseCase>(() => GetDisplayStocksUseCase());

  getIt.registerLazySingleton<ToggleCatalogUseCase>(() => ToggleCatalogUseCase());
  getIt.registerLazySingleton<LoadCatalogUseCase>(() => LoadCatalogUseCase());
  getIt.registerLazySingleton<CloseCatalogUseCase>(() => CloseCatalogUseCase());
  getIt.registerLazySingleton<SelectCatalogUseCase>(() => SelectCatalogUseCase());
  getIt.registerLazySingleton<AddCatalogUseCase>(() => AddCatalogUseCase());
  getIt.registerLazySingleton<RenameCatalogUseCase>(() => RenameCatalogUseCase());
  getIt.registerLazySingleton<DeleteCatalogUseCase>(() => DeleteCatalogUseCase());
  getIt.registerLazySingleton<ClearCatalogUseCase>(() => ClearCatalogUseCase());
  getIt.registerLazySingleton<AddStockToCatalogUseCase>(() => AddStockToCatalogUseCase());
  getIt.registerLazySingleton<DeleteStockFromCatalogUseCase>(() => DeleteStockFromCatalogUseCase());
}