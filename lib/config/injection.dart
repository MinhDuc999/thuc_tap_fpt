import 'package:btcat_di_getit/data/repositories/cat_repository_impl.dart';
import 'package:btcat_di_getit/doman/repositories/cat_repository.dart';
import 'package:btcat_di_getit/presentations/cat/cat_notifier.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../data/service/cat_service.dart';

final getIt =GetIt.instance;

Future<void> init() async {
  getIt.registerLazySingleton<CatService>(() => CatService(Dio()));
  getIt.registerLazySingleton<CatRepository>(() => CatRepositoryImpl());
  getIt.registerFactory<CatNotifier>(() => CatNotifier());
}