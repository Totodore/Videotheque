import 'package:flutter/cupertino.dart';

const bool isProduction = bool.fromEnvironment('dart.vm.product');

@immutable
class Env {
  final TMDB_LINK = "api.themoviedb.org";
  final TMDB_IMAGE_LINK = "https://image.tmdb.org/t/p";
  final TMDB_API_KEY = "a6499d6e1a486416773626640f79de9d";
  final YT_API_KEY = "AIzaSyAJgzmg3zxU6nhQOOlb6EZ2NN4i5-yJsYo";
} 

final Env environment = Env();