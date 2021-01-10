import 'dart:convert';
import 'package:http/http.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/utils/Utils.dart';

class TMDBQueries {

  static const String key = GlobalsData.apiKey;
  static const String lang = GlobalsData.lang; 
  static const String api_endpoint = "https://api.themoviedb.org/3";

  static Future<Response> actualQuerySearch;

  static Future<Map<String, dynamic>> onlineSearchMulti(String query, [int offset = 1]) async {
    return TMDBQueries.sortNoContent(await defaultQuery("$api_endpoint/search/multi?api_key=$key&language=$lang&page=$offset&include_adult=false&query=$query"), QueryTypes.all);
  }

  static Future<Map<String, dynamic>> onlineSearchMovie(String query, [int offset = 1]) async {
    return TMDBQueries.sortNoContent(await defaultQuery("$api_endpoint/search/movie?api_key=$key&page=$offset&language=$lang&include_adult=false&query=$query"), QueryTypes.movie);
  }

  static Future<Map<String, dynamic>> onlineSearchPerson(String query, [int offset = 1]) async {
    return TMDBQueries.sortNoContent(await defaultQuery("$api_endpoint/search/person?api_key=$key&language=$lang&query=$query&page=$offset"), QueryTypes.person);
  }

  static Future<Map<String, dynamic>> onlineSearchCollection(String query, [int offset = 1]) async {
    return TMDBQueries.sortNoContent(await defaultQuery("$api_endpoint/search/collection?api_key=$key&language=$lang&query=$query&page=$offset"), QueryTypes.collection);
  }

  // static Future<Map<String, dynamic>> onlineSearchCompanies(String query, [int offset = 1]) async {
  //   return TMDBQueries.sortNoContent(await defaultQuery("$api_endpoint/search/company?api_key=$key&page=$offset&&query=$query&language=$lang"), QueryTypes.companies);
  // }

  static Future<Map<String, dynamic>> onlineSearchTV(String query, [int offset = 1]) async {
    return TMDBQueries.sortNoContent(await defaultQuery("$api_endpoint/search/tv?api_key=$key&language=$lang&page=$offset&include_adult=false&query=$query"), QueryTypes.tv);
  }

  static Future<Map<String, dynamic>> getMovie(String id) async {
    return defaultQuery("$api_endpoint/movie/$id?api_key=$key&language=$lang");
  }

  static Future<Map<String, dynamic>> getPerson(String id) async {
    return defaultQuery("$api_endpoint/person/$id?api_key=$key&language=$lang");
  }
  static Future<Map<String, dynamic>> getKnownForMovies(String id) async {
    return defaultQuery("$api_endpoint/person/$id/movie_credits?api_key=$key&language=$lang");
  }

  static Future<Map<String, dynamic>> getKnownForTv(String id) async {
    return defaultQuery("$api_endpoint/person/$id/tv_credits?api_key=$key&language=$lang");
  }

  static Future<Map<String, dynamic>> getTagListMovie() async {
    return defaultQuery("$api_endpoint/genre/movie/list?api_key=$key&language=$lang");
  }
  static Future<Map<String, dynamic>> getTagListTv() async {
    return defaultQuery("$api_endpoint/genre/tv/list?api_key=$key&language=$lang");
  }

  static Future<Map<String, dynamic>> getMovieCredits(String id) async {
    return defaultQuery("$api_endpoint/movie/$id/credits?api_key=$key&language=$lang");
  }

  static Future<Map<String, dynamic>> getMovieSimilar(String id) async {
    return defaultQuery("$api_endpoint/movie/$id/similar?api_key=$key&language=$lang");
  }

  static Future<Map<String, dynamic>> getMovieTrailer(String id) async {
    return defaultQuery("$api_endpoint/movie/$id/videos?api_key=$key&language=$lang");
  }

  static Future<Map<String, dynamic>> getMovieRecommendation(String id) {
    return defaultQuery("$api_endpoint/movie/$id/recommendations?api_key=$key&language=$lang");
  }

  static Future<Map<String, dynamic>> getTv(String id) async {
    return defaultQuery("$api_endpoint/tv/$id?api_key=$key&language=$lang");
  }
  static Future<Map<String, dynamic>> getTvCredits(String id) async {
    return defaultQuery("$api_endpoint/tv/$id/credits?api_key=$key&language=$lang");
  }
  static Future<Map<String, dynamic>> getTvSimilar(String id) async {
    return defaultQuery("$api_endpoint/tv/$id/similar?api_key=$key&language=$lang");
  }
  static Future<Map<String, dynamic>> getTvRecommendation(String id) {
    return defaultQuery("$api_endpoint/tv/$id/recommendations?api_key=$key&language=$lang");
  }
  static Future<Map<String, dynamic>> getTvSeason(String id, String seasonNumber) async {
    return defaultQuery("$api_endpoint/tv/$id/season/$seasonNumber?api_key=$key&language=$lang");
  }
  static Future<Map<String, dynamic>> getTvSeasonCredits(String id, String seasonNumber) async {
    return defaultQuery("$api_endpoint/tv/$id/season/$seasonNumber/credits?api_key=$key&language=$lang");
  }
  static Future<Map<String, dynamic>> getTvSeasonVideos(String id, String seasonNumber) async {
    return defaultQuery("$api_endpoint/tv/$id/season/$seasonNumber/videos?api_key=$key&language=$lang");
  }
  static Future<Map<String, dynamic>> getTvEpisode(String id, String seasonNumber, String episodeNumber) async {
    return defaultQuery("$api_endpoint/tv/$id/season/$seasonNumber/episode/$episodeNumber?api_key=$key&language=$lang");
  }
  static Future<Map<String, dynamic>> getTvEpisodesCredits(String id, String seasonNumber, String episodeNumber) async {
    return defaultQuery("$api_endpoint/tv/$id/season/$seasonNumber/episode/$episodeNumber/credits?api_key=$key&language=$lang");
  }
  static Future<Map<String, dynamic>> getTvEpisodesVideos(String id, String seasonNumber, String episodeNumber) async {
    return defaultQuery("$api_endpoint/tv/$id/season/$seasonNumber/episode/$episodeNumber/videos?api_key=$key&language=$lang");
  }
  static Future<Map<String, dynamic>> getCollection(String id) {
    return defaultQuery("$api_endpoint/collection/$id?api_key=$key&language=$lang");
  }

  static Map<String, dynamic> sortNoContent(Map<String, dynamic> toSort, QueryTypes queryTypes) {
    if (toSort["results"] == null)  //En cas d'erreur
      return toSort;
    toSort["results"].removeWhere((el) => el["poster_path"] == null && el["profile_path"] == null);

    return toSort;
  }

  static Future<Map<String, dynamic>> defaultQuery(String url) async {
    Map<String, dynamic> returner;
    Future<Response> queryFuture;
    queryFuture = Utils.fetchData(url).catchError((onError) => returner = Map.from({"error": GlobalsMessage.defaultError}));
    Response response;
    bool error = false;
    try {
      response = await queryFuture;
    } on TypeError {
      error = true;
      print("Erreur qui vient de je ne sais où");
    }
    if (!error && response.statusCode == 200) {
      returner = jsonDecode(response.body);
    }
    return returner;
  }

  static List sortByPopularity(List input) {
    if (input != null)
      input.sort((el1, el2) {
        try {
          return el1["popularity"] < el2["popularity"] ? 1 : -1;
        } on NoSuchMethodError {
          return -1;
        }
      });
    return input;
  }
} 