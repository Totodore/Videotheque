// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ApiSearchCollectionModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiSearchCollectionModel _$ApiSearchCollectionModelFromJson(
    Map<String, dynamic> json) {
  return ApiSearchCollectionModel(
    json['id'] as int,
    json['poster_path'] as String,
    json['backdrop_path'] as String,
    json['name'] as String,
  );
}

Map<String, dynamic> _$ApiSearchCollectionModelToJson(
        ApiSearchCollectionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'backdrop_path': instance.backdrop_path,
      'name': instance.name,
      'poster_path': instance.poster_path,
    };
