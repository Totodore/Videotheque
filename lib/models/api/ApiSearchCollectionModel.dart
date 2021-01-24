
import 'dart:convert';

import 'package:Videotheque/models/api/ApiSearchElModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ApiSearchCollectionModel.g.dart';

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
}