import 'package:get_it/get_it.dart';
import 'package:ui_dieu_huong/doman/usecase/feature/all_feature_usecase.dart';
import 'package:ui_dieu_huong/doman/usecase/feature/remove_feature_usecase.dart';
import 'package:ui_dieu_huong/doman/usecase/feature/replace_feature_usecase.dart';
import 'package:ui_dieu_huong/doman/usecase/tab/change_button_usecase.dart';
import 'package:ui_dieu_huong/doman/usecase/tab/change_tab_usecase.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerLazySingleton<AllFeatureUsecase>(() => AllFeatureUsecase());
  getIt.registerLazySingleton<RemoveFeatureUsecase>(() => RemoveFeatureUsecase());
  getIt.registerLazySingleton<ReplaceFeatureUsecase>(() => ReplaceFeatureUsecase());
  getIt.registerLazySingleton<ChangeTabUsecase>(() => ChangeTabUsecase());
  getIt.registerLazySingleton<ChangeButtonUsecase>(() => ChangeButtonUsecase());
}