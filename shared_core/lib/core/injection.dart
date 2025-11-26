import 'package:get_it/get_it.dart';
import 'package:shared_core/data/repositories/navi_repository_impl.dart';
import 'package:shared_core/domain/repositories/navi_repository.dart';
import 'package:shared_core/domain/usecase/feature/all_feature_usecase.dart';
import 'package:shared_core/domain/usecase/feature/close_search_view_usecase.dart';
import 'package:shared_core/domain/usecase/feature/open_search_view_usecase.dart';
import 'package:shared_core/domain/usecase/feature/remove_feature_usecase.dart';
import 'package:shared_core/domain/usecase/feature/replace_feature_usecase.dart';
import 'package:shared_core/domain/usecase/feature/search_feature_usecase.dart';
import 'package:shared_core/domain/usecase/tab/change_button_usecase.dart';
import 'package:shared_core/domain/usecase/tab/change_tab_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';


final getIt = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

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