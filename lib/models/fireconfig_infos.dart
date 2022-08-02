
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'FireconfigInfos.g.dart';

@JsonSerializable(nullable: true)
class FireconfigInfos {

  final String id;
  final String content;
  final bool dismissible;
  final String link;
  final String link_content;
  final bool dismiss_click;

  FireconfigInfos(this.id, this.content, this.dismissible, this.link, this.link_content, this.dismiss_click);

  factory FireconfigInfos.fromJson(Map<String, dynamic> json) => _$FireconfigInfosFromJson(json);

  factory FireconfigInfos.fromString(String json) => _$FireconfigInfosFromJson(jsonDecode(json));
  Map<String, dynamic> toJson() => _$FireconfigInfosToJson(this);
}