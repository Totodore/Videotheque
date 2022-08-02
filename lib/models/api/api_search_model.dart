
import 'dart:convert';

import 'package:Videotheque/models/api/api_search_el_model.dart';
import 'package:Videotheque/models/converters/searchel_converter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'api_search_model.g.dart';

@JsonSerializable(nullable: true)
class ApiSearchModel<T extends ApiSearchElModel> {

  final int page;

  @SearchElConverter()
  final List<T> results;
  final int total_results;
  final int total_pages;
  final String error;

  ApiSearchModel(this.page, this.results, this.total_pages, this.total_results, this.error);

  ApiSearchModel<K> asAll<K extends ApiSearchElModel>() => this as ApiSearchModel<K>;
  factory ApiSearchModel.fromJson(Map<String, dynamic> json) => _$ApiSearchModelFromJson<T>(json);

  factory ApiSearchModel.fromString(String json) => _$ApiSearchModelFromJson<T>(jsonDecode(json));

  Map<String, dynamic> toJson() => _$ApiSearchModelToJson<T>(this);

  static List<T> dataFromJson<T>(Map<String, dynamic> data) => data['results'] as List<T>;

  static Map<String, dynamic> dataToJson<T>(List<T> input) => {'results': input};
}