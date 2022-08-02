
import 'package:Videotheque/models/api/ApiSearchElModel.dart';
import 'package:Videotheque/models/api/ApiSearchMovieModel.dart';
import 'package:Videotheque/models/api/ApiSearchPersonModel.dart';
import 'package:Videotheque/models/api/ApiSearchTvModel.dart';
import 'package:Videotheque/models/api/ApiSearchCollectionModel.dart';
import 'package:json_annotation/json_annotation.dart';

class SearchElConverter<T extends ApiSearchElModel> implements JsonConverter<T, Object> {
  const SearchElConverter();

  /**
   * Convert an TMDB search element from json
   * If it comes from multi search then the flag media_type is checked
   * Otherwise the type T is directly converted
   */
  @override
  T fromJson(Object json) {
    if (json is Map<String, dynamic>) {
      if (json["media_type"] != null ){
        switch (json["media_type"]) {
          case "movie":
            return ApiSearchMovieModel.fromJson(json) as T;
          case "tv":
            return ApiSearchTvModel.fromJson(json) as T;
          case "person":
            return ApiSearchPersonModel.fromJson(json) as T;
          case "collection":
            return ApiSearchCollectionModel.fromJson(json) as T;
        }
      } else {
        switch(T) {
          case ApiSearchMovieModel:
            return ApiSearchMovieModel.fromJson(json) as T;
          case ApiSearchTvModel:
            return ApiSearchTvModel.fromJson(json) as T;
          case ApiSearchPersonModel:
            return ApiSearchPersonModel.fromJson(json) as T;
          case ApiSearchCollectionModel:
            return ApiSearchCollectionModel.fromJson(json) as T;
        }
      }
    } return null;
  }

  @override
  Map<String, dynamic> toJson(T data) {
    return data.toJson();
  }
}