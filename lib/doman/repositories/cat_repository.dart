import '../../models/cat_model/cat_model.dart';

abstract class CatRepository{
  Future<List<CatModel>> getCatImages();
}