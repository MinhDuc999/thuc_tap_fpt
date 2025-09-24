import 'package:btcat_di_getit/models/cat_model/cat_model.dart';
import 'package:retrofit/http.dart';
import 'package:dio/dio.dart';
import '../../config/api_key.dart';

part 'cat_service.g.dart';

@RestApi(baseUrl: ApiKeys.catApi)
abstract class CatService{
  factory CatService(Dio dio, {String baseUrl}) = _CatService;

  @GET("images/search")
  Future<List<CatModel>> getCats(@Query("limit") int limit);
}