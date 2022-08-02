// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiSearchModel<T> _$ApiSearchModelFromJson<T extends ApiSearchElModel>(
    Map<String, dynamic> json) {
  return ApiSearchModel<T>(
    json['page'] as int,
    (json['results'] as List)?.map(SearchElConverter<T>().fromJson)?.toList(),
    json['total_pages'] as int,
    json['total_results'] as int,
    json['error'] as String,
  );
}

Map<String, dynamic> _$ApiSearchModelToJson<T extends ApiSearchElModel>(
        ApiSearchModel<T> instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.results?.map(SearchElConverter<T>().toJson)?.toList(),
      'total_results': instance.total_results,
      'total_pages': instance.total_pages,
      'error': instance.error,
    };
