
import 'dart:convert';

import 'package:Videotheque/models/api/api_search_movie_model.dart';
import 'package:Videotheque/models/api/api_search_person_model.dart';
import 'package:Videotheque/models/api/api_search_tv_model.dart';
import 'package:Videotheque/models/api/api_search_collection_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_search_el_model.g.dart';

@JsonSerializable(nullable: true)
class ApiSearchElModel {

  final int id;
  final String media_type;


  ApiSearchElModel(this.id, this.media_type);

  T getAs<T>() {
    switch (T) {
      case ApiSearchMovieModel:
        return ApiSearchMovieModel.fromJson(this.toJson()) as T;
      case ApiSearchTvModel:
        return ApiSearchTvModel.fromJson(this.toJson()) as T;
      case ApiSearchPersonModel:
        return ApiSearchPersonModel.fromJson(this.toJson()) as T;
      case ApiSearchCollectionModel:
        return ApiSearchCollectionModel.fromJson(this.toJson()) as T;
    }
    return null;
  }

  factory ApiSearchElModel.fromJson(Map<String, dynamic> json) {
    return _$ApiSearchElModelFromJson(json);
  }

  factory ApiSearchElModel.fromString(String json) => _$ApiSearchElModelFromJson(jsonDecode(json));
  Map<String, dynamic> toJson() => _$ApiSearchElModelToJson(this);
}