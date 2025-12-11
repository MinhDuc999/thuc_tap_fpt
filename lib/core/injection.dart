import 'package:get_it/get_it.dart';
import 'package:ui_bang_gia/data/database/database_helper.dart';
import 'package:ui_bang_gia/data/repository/price_board_repository_impl.dart';
import 'package:ui_bang_gia/domain/repository/price_board_repository.dart';
import 'package:ui_bang_gia/domain/usecase/catalog/catalog_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/filterCell/filter_cell_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/market/filter_market_by_category_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/market/get_display_stocks_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/market/load_market_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/market/sort_market_usecase.dart';
import 'package:ui_bang_gia/domain/usecase/market/market_usecase.dart';
final getIt = GetIt.instance;

Future<void> init() async{

  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());


  getIt.registerLazySingleton<CatalogRepository>(() => CatalogRepositoryImpl());
  getIt.registerLazySingleton<FilterCellRepository>(() => FilterCellRepositoryImpl());
  getIt.registerLazySingleton<MarketStateRepository>(() => MarketStateRepositoryImpl());

  getIt.registerLazySingleton<ToggleMarketMenuUseCase>(() => ToggleMarketMenuUseCase());
  getIt.registerLazySingleton<CloseMarketMenuUseCase>(() => CloseMarketMenuUseCase());
  getIt.registerLazySingleton<SelectSubMenuItemUseCase>(() => SelectSubMenuItemUseCase());
  getIt.registerLazySingleton<SelectMarketCategoryUseCase>(() => SelectMarketCategoryUseCase());
  getIt.registerLazySingleton<ClearMarketSelectUseCase>(() => ClearMarketSelectUseCase());

  getIt.registerLazySingleton<FilterMarketDataUseCase>(() => FilterMarketDataUseCase());
  getIt.registerLazySingleton<LoadMarketDataUseCase>(() => LoadMarketDataUseCase());
  getIt.registerLazySingleton<SortMarketDataUseCase>(() => SortMarketDataUseCase());

  getIt.registerLazySingleton<MuaBan3UseCase>(() => MuaBan3UseCase());
  getIt.registerLazySingleton<NNMuaBanUseCase>(() => NNMuaBanUseCase());
  getIt.registerLazySingleton<SetKhoiLuongUseCase>(() => SetKhoiLuongUseCase());
  getIt.registerLazySingleton<MoCuaUseCase>(() => MoCuaUseCase());

  getIt.registerLazySingleton<LoadMarketUseCase>(() => LoadMarketUseCase());
  getIt.registerLazySingleton<SortMarketUseCase>(() => SortMarketUseCase());
  getIt.registerLazySingleton<FilterMarketByCategoryUseCase>(() => FilterMarketByCategoryUseCase());
  getIt.registerLazySingleton<GetDisplayStocksUseCase>(() => GetDisplayStocksUseCase());

  getIt.registerLazySingleton<ToggleCatalogUseCase>(() => ToggleCatalogUseCase());
  getIt.registerLazySingleton<CloseCatalogUseCase>(() => CloseCatalogUseCase());
  getIt.registerLazySingleton<SelectCatalogUseCase>(() => SelectCatalogUseCase());
  getIt.registerLazySingleton<AddCatalogUseCase>(() => AddCatalogUseCase());
  getIt.registerLazySingleton<RenameCatalogUseCase>(() => RenameCatalogUseCase());
  getIt.registerLazySingleton<DeleteCatalogUseCase>(() => DeleteCatalogUseCase());
  getIt.registerLazySingleton<ClearCatalogUseCase>(() => ClearCatalogUseCase());
  getIt.registerLazySingleton<AddStockToCatalogUseCase>(() => AddStockToCatalogUseCase());
  getIt.registerLazySingleton<DeleteStockFromCatalogUseCase>(() => DeleteStockFromCatalogUseCase());
}