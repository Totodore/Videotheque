
import 'dart:convert';

import 'package:Videotheque/models/api/api_search_el_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_search_collection_model.g.dart';

@JsonSerializable(nullable: true)
class ApiSearchCollectionModel extends ApiSearchElModel {

  final int id;
  final String media_type = "collection";
  final String backdrop_path;
  final String name;
  final String poster_path;

  ApiSearchCollectionModel(this.id, this.poster_path, this.backdrop_path, this.name) : super(id, "collection");

  factory ApiSearchCollectionModel.fromJson(Map<String, dynamic> json) => _$ApiSearchCollectionModelFromJson(json);

  factory ApiSearchCollectionModel.fromString(String json) => _$ApiSearchCollectionModelFromJson(jsonDecode(json));
  Map<String, dynamic> toJson() => _$ApiSearchCollectionModelToJson(this);

  bool get hasImg => poster_path != null;
  bool get hasBody => hasImg;

}