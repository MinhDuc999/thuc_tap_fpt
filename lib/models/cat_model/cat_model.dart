import 'package:json_annotation/json_annotation.dart';

part 'cat_model.g.dart';

@JsonSerializable()
class CatModel{
  final String id;
  final String url;
  final int width;
  final int height;

  CatModel({required this.id,required this.url,required this.width,required this.height});

  factory CatModel.fromJson(Map<String, dynamic> json) => _$CatModelFromJson(json);
  Map<String,dynamic> toJson() => _$CatModelToJson(this);
}