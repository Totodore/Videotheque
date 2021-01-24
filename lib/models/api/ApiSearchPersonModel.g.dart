// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ApiSearchPersonModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiSearchPersonModel _$ApiSearchPersonModelFromJson(Map<String, dynamic> json) {
  return ApiSearchPersonModel(
    json['id'] as int,
    json['profile_path'] as String,
    json['adult'] as bool,
    json['name'] as String,
    (json['popularity'] as num)?.toDouble(),
    (json['known_for'] as List)
        ?.map((e) => e == null
            ? null
            : ApiSearchElModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ApiSearchPersonModelToJson(
        ApiSearchPersonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profile_path': instance.profile_path,
      'adult': instance.adult,
      'name': instance.name,
      'popularity': instance.popularity,
      'known_for': ApiSearchPersonModel._knownForToJson(instance.known_for),
    };
