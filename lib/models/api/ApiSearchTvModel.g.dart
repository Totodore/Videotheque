// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ApiSearchTvModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiSearchTvModel _$ApiSearchTvModelFromJson(Map<String, dynamic> json) {
  return ApiSearchTvModel(
    json['id'] as int,
    json['poster_path'] as String,
    json['overview'] as String,
    (json['genre_ids'] as List)?.map((e) => e as int)?.toList(),
    json['original_language'] as String,
    json['backdrop_path'] as String,
    (json['popularity'] as num)?.toDouble(),
    (json['vote_average'] as num)?.toDouble(),
    json['vote_count'] as int,
    json['first_air'] as String,
    json['name'] as String,
    (json['origin_country'] as List)?.map((e) => e as String)?.toList(),
    json['original_name'] as String,
  );
}

Map<String, dynamic> _$ApiSearchTvModelToJson(ApiSearchTvModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'poster_path': instance.poster_path,
      'popularity': instance.popularity,
      'overview': instance.overview,
      'backdrop_path': instance.backdrop_path,
      'vote_average': instance.vote_average,
      'first_air': instance.first_air,
      'origin_country': instance.origin_country,
      'genre_ids': instance.genre_ids,
      'original_language': instance.original_language,
      'vote_count': instance.vote_count,
      'name': instance.name,
      'original_name': instance.original_name,
    };
