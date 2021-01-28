
import 'dart:convert';

import 'package:Videotheque/models/api/ApiSearchElModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ApiSearchMovieModel.g.dart';

@JsonSerializable(nullable: true)
class ApiSearchMovieModel extends ApiSearchElModel {

  final int id;
  final String poster_path;
  final bool adult;
  final String overview;
  final DateTime release_date;
  final String original_title;
  final List<int> genre_ids;
  final String media_type = "movie";
  final String original_language;
  final String title;
  final String backdrop_path;
  final double popularity;
  final int vote_count;
  final bool video;
  final double vote_average;

  ApiSearchMovieModel(this.id, this.poster_path, this.adult, this.overview, this.release_date, this.original_title, this.genre_ids, this.original_language, this.title, this.backdrop_path, this.popularity, this.vote_average, this.vote_count, this.video) : super(id, "movie");

  factory ApiSearchMovieModel.fromJson(Map<String, dynamic> json) => _$ApiSearchMovieModelFromJson(json);

  factory ApiSearchMovieModel.fromString(String json) => _$ApiSearchMovieModelFromJson(jsonDecode(json));
  Map<String, dynamic> toJson() => _$ApiSearchMovieModelToJson(this);
}