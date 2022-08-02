import 'dart:convert';
import 'package:Videotheque/Env.dart';
import 'package:Videotheque/models/api/ApiSearchCollectionModel.dart';
import 'package:Videotheque/models/api/ApiSearchModel.dart';
import 'package:Videotheque/models/api/ApiSearchMovieModel.dart';
import 'package:Videotheque/models/api/ApiSearchPersonModel.dart';
import 'package:Videotheque/models/api/ApiSearchTvModel.dart';
import 'package:http/http.dart';
import 'package:Videotheque/Globals.dart';
import 'package:Videotheque/utils/Utils.dart';
import 'package:path/path.dart' as p;

class TMDBQueries {

  static const String lang = GlobalsData.lang; 

  Future<Response> actualQuerySearch;


  Future<ApiSearchModel> onlineSearchMulti(String query, [int offset = 1]) async {
    var content = await searchQuery("search/multi", query, offset);
    return ApiSearchModel.fromJson(content);
  }

  Future<ApiSearchModel<ApiSearchMovieModel>> onlineSearchMovie(String query, [int offset = 1]) async {
    var content = await searchQuery("search/movie", query, offset);
    return ApiSearchModel<ApiSearchMovieModel>.fromJson(content);
  }

  Future<ApiSearchModel<ApiSearchPersonModel>> onlineSearchPerson(String query, [int offset = 1]) async {
    var content = await searchQuery("search/person", query, offset);
    return ApiSearchModel<ApiSearchPersonModel>.fromJson(content);
  }

  Future<ApiSearchModel<ApiSearchCollectionModel>> onlineSearchCollection(String query, [int offset = 1]) async {
    var content = await searchQuery("search/collection", query, offset);
    return ApiSearchModel<ApiSearchCollectionModel>.fromJson(content);
  }

  Future<ApiSearchModel<ApiSearchTvModel>> onlineSearchTV(String query, [int offset = 1]) async {
    var content = await searchQuery("search/tv", query, offset);
    return ApiSearchModel<ApiSearchTvModel>.fromJson(content);
  }

  Future<Map<String, dynamic>> getMovie(String id) async {
    return defaultQuery("movie/$id");
  }

  Future<Map<String, dynamic>> getPerson(String id) async {
    return defaultQuery("person/$id");
  }
  Future<Map<String, dynamic>> getKnownForMovies(String id) async {
    return defaultQuery("person/$id/movie_credits");
  }

  Future<Map<String, dynamic>> getKnownForTv(String id) async {
    return defaultQuery("person/$id/tv_credits");
  }

  Future<Map<String, dynamic>> getTagListMovie() async {
    return defaultQuery("genre/movie/list");
  }
  Future<Map<String, dynamic>> getTagListTv() async {
    return defaultQuery("genre/tv/list");
  }

  Future<Map<String, dynamic>> getMovieCredits(String id) async {
    return defaultQuery("movie/$id/credits");
  }

  Future<Map<String, dynamic>> getMovieSimilar(String id) async {
    return defaultQuery("movie/$id/similar");
  }

  Future<Map<String, dynamic>> getMovieTrailer(String id) async {
    return defaultQuery("movie/$id/videos");
  }

  Future<Map<String, dynamic>> getMovieRecommendation(String id) {
    return defaultQuery("movie/$id/recommendations");
  }

  Future<Map<String, dynamic>> getTv(String id) async {
    return defaultQuery("tv/$id");
  }
  Future<Map<String, dynamic>> getTvCredits(String id) async {
    return defaultQuery("tv/$id/credits");
  }
  Future<Map<String, dynamic>> getTvSimilar(String id) async {
    return defaultQuery("tv/$id/similar");
  }
  Future<Map<String, dynamic>> getTvRecommendation(String id) {
    return defaultQuery("tv/$id/recommendations");
  }
  Future<Map<String, dynamic>> getTvSeason(String id, String seasonNumber) async {
    return defaultQuery("tv/$id/season/$seasonNumber");
  }
  Future<Map<String, dynamic>> getTvSeasonCredits(String id, String seasonNumber) async {
    return defaultQuery("tv/$id/season/$seasonNumber/credits");
  }
  Future<Map<String, dynamic>> getTvSeasonVideos(String id, String seasonNumber) async {
    return defaultQuery("tv/$id/season/$seasonNumber/videos");
  }
  Future<Map<String, dynamic>> getTvEpisode(String id, String seasonNumber, String episodeNumber) async {
    return defaultQuery("tv/$id/season/$seasonNumber/episode/$episodeNumber");
  }
  Future<Map<String, dynamic>> getTvEpisodesCredits(String id, String seasonNumber, String episodeNumber) async {
    return defaultQuery("tv/$id/season/$seasonNumber/episode/$episodeNumber/credits");
  }
  Future<Map<String, dynamic>> getTvEpisodesVideos(String id, String seasonNumber, String episodeNumber) async {
    return defaultQuery("tv/$id/season/$seasonNumber/episode/$episodeNumber/videos");
  }
  Future<Map<String, dynamic>> getCollection(String id) {
    return defaultQuery("collection/$id");
  }

  Future<Map<String, dynamic>> searchQuery(String path, String query, int offset) async {
    return defaultQuery(path, { "query": query, "offset": offset.toString() });
  }
  Future<Map<String, dynamic>> defaultQuery(String path, [Map<String, String> params]) async {
    Uri url = new Uri.https(environment.TMDB_LINK, p.join("3", path), (params ?? new Map())..addAll({
      "api_key": environment.TMDB_API_KEY,
      "language": lang,
      "include_adult": "false"
    }));
    Map<String, dynamic> returner;
    Future<Response> queryFuture;
    queryFuture = Utils.fetchData(url.toString()).catchError((onError) => returner = Map.from({"error": GlobalsMessage.defaultError}));
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

  List sortByPopularity(List input) {
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