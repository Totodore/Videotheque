// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_search_movie_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiSearchMovieModel _$ApiSearchMovieModelFromJson(Map<String, dynamic> json) {
  return ApiSearchMovieModel(
    json['id'] as int,
    json['poster_path'] as String,
    json['adult'] as bool,
    json['overview'] as String,
    const DateTimeConverter().fromJson(json['release_date'] as String),
    json['original_title'] as String,
    (json['genre_ids'] as List)?.map((e) => e as int)?.toList(),
    json['original_language'] as String,
    json['title'] as String,
    json['backdrop_path'] as String,
    (json['popularity'] as num)?.toDouble(),
    (json['vote_average'] as num)?.toDouble(),
    json['vote_count'] as int,
    json['video'] as bool,
  );
}

Map<String, dynamic> _$ApiSearchMovieModelToJson(
        ApiSearchMovieModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'poster_path': instance.poster_path,
      'adult': instance.adult,
      'overview': instance.overview,
      'release_date': const DateTimeConverter().toJson(instance.release_date),
      'original_title': instance.original_title,
      'genre_ids': instance.genre_ids,
      'original_language': instance.original_language,
      'title': instance.title,
      'backdrop_path': instance.backdrop_path,
      'popularity': instance.popularity,
      'vote_count': instance.vote_count,
      'video': instance.video,
      'vote_average': instance.vote_average,
    };
