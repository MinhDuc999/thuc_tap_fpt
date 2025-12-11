import 'package:get_it/get_it.dart';
import 'package:shared_core/data/database/database_helper.dart';
import 'package:shared_core/data/repositories/navi_repository_impl.dart';
import 'package:shared_core/domain/repositories/navi_repository.dart';
import 'package:shared_core/domain/usecase/feature/feature_usecase.dart';


final getIt = GetIt.instance;

Future<void> init() async {

  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  getIt.registerLazySingleton<NavigationRepository>(() => NavigationRepositoryImpl());

  getIt.registerLazySingleton<AllFeatureUseCase>(() => AllFeatureUseCase());
  getIt.registerLazySingleton<RemoveFeatureUseCase>(() => RemoveFeatureUseCase());
  getIt.registerLazySingleton<ReplaceFeatureUseCase>(() => ReplaceFeatureUseCase());
  getIt.registerLazySingleton<SearchFeatureUseCase>(() => SearchFeatureUseCase());
  getIt.registerLazySingleton<OpenSearchViewUseCase>(() => OpenSearchViewUseCase());
  getIt.registerLazySingleton<CloseSearchViewUseCase>(() => CloseSearchViewUseCase());
  getIt.registerLazySingleton<ChangeTabUseCase>(() => ChangeTabUseCase());
  getIt.registerLazySingleton<ChangeButtonUseCase>(() => ChangeButtonUseCase());
}