
import 'dart:convert';

import 'package:Videotheque/models/api/ApiSearchElModel.dart';
import 'package:Videotheque/models/api/ApiSearchTvModel.dart';
import 'package:Videotheque/models/api/ApiSearchMovieModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ApiSearchPersonModel.g.dart';

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
}