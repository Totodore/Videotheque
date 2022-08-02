import 'package:json_annotation/json_annotation.dart';

class DateTimeConverter implements JsonConverter<DateTime, String> {

  const DateTimeConverter();

  @override
  DateTime fromJson(String date) {
    try {
      return DateTime.parse(date);
    } catch(e) {
      return null;
    }
  }

  @override
  String toJson(DateTime date) {
    try {
      return date.toIso8601String();
    } catch(e) {
      return null;
    }
  }
}