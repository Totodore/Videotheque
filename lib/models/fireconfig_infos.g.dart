// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fireconfig_infos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FireconfigInfos _$FireconfigInfosFromJson(Map<String, dynamic> json) {
  return FireconfigInfos(
    json['id'] as String,
    json['content'] as String,
    json['dismissible'] as bool,
    json['link'] as String,
    json['link_content'] as String,
    json['dismiss_click'] as bool,
  );
}

Map<String, dynamic> _$FireconfigInfosToJson(FireconfigInfos instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'dismissible': instance.dismissible,
      'link': instance.link,
      'link_content': instance.link_content,
      'dismiss_click': instance.dismiss_click,
    };
