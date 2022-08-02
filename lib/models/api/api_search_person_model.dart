
import 'dart:convert';

import 'package:Videotheque/models/api/api_search_el_model.dart';
import 'package:Videotheque/models/api/api_search_tv_model.dart';
import 'package:Videotheque/models/api/api_search_movie_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_search_person_model.g.dart';

@JsonSerializable(nullable: true)
class ApiSearchPersonModel extends ApiSearchElModel {

  final int id;
  final String profile_path;
  final bool adult;
  final String name;
  final double popularity;

  @JsonKey(toJson: _knownForToJson, fromJson: _knownForFromJson)
  final List<dynamic> known_for;

  final String media_type = "person";

  ApiSearchPersonModel(this.id, this.profile_path, this.adult, this.name, this.popularity, this.known_for) : super(id, "person");

  factory ApiSearchPersonModel.fromJson(Map<String, dynamic> json) => _$ApiSearchPersonModelFromJson(json);

  factory ApiSearchPersonModel.fromString(String json) => _$ApiSearchPersonModelFromJson(jsonDecode(json));
  Map<String, dynamic> toJson() => _$ApiSearchPersonModelToJson(this);

  static List _knownForToJson(List list) => list.map((el) => el.toJson()).toList();

  static List _knownForFromJson(List list) =>
    list.map((el) {
      return el["title"] != null ? ApiSearchMovieModel.fromJson(el) : ApiSearchTvModel.fromJson(el);
    }).toList();

  bool get hasImg => profile_path != null;
  bool get hasBody => hasImg || (known_for?.length ?? 0) > 0;

}