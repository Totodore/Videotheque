// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_search_person_model.dart';

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
    ApiSearchPersonModel._knownForFromJson(json['known_for'] as List),
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
