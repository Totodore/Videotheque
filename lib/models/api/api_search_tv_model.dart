
import 'dart:convert';

import 'package:Videotheque/models/api/api_search_el_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_search_tv_model.g.dart';

@JsonSerializable(nullable: true)
class ApiSearchTvModel extends ApiSearchElModel {

  final int id;
  final String poster_path;
  final double popularity;
  final String overview;
  final String backdrop_path;
  final double vote_average;
  final String first_air;
  final List<String> origin_country;
  final List<int> genre_ids;
  final String original_language;
  final int vote_count;
  final String name;
  final String original_name;
  final String media_type = "tv";

  ApiSearchTvModel(this.id, this.poster_path, this.overview, this.genre_ids, this.original_language, this.backdrop_path, this.popularity, this.vote_average, this.vote_count, this.first_air, this.name, this.origin_country, this.original_name) : super(id, "tv");

  factory ApiSearchTvModel.fromJson(Map<String, dynamic> json) => _$ApiSearchTvModelFromJson(json);

  factory ApiSearchTvModel.fromString(String json) => _$ApiSearchTvModelFromJson(jsonDecode(json));
  Map<String, dynamic> toJson() => _$ApiSearchTvModelToJson(this);

  bool get hasImg => poster_path != null;
  bool get hasBody => hasImg || (overview?.length ?? 0) > 2;

}