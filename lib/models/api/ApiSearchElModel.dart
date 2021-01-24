
import 'dart:convert';

import 'package:Videotheque/models/api/ApiSearchMovieModel.dart';
import 'package:Videotheque/models/api/ApiSearchPersonModel.dart';
import 'package:Videotheque/models/api/ApiSearchTvModel.dart';
import 'package:Videotheque/models/api/ApiSearchCollectionModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ApiSearchElModel.g.dart';

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