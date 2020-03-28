import 'dart:convert';
import 'package:http/http.dart';
import 'package:Videotheque/globals.dart';

class TMDBQueries {

  static const String key = GlobalsData.apiKey;
  static const String lang = GlobalsData.lang; 

  static Future<Response> actualQuerySearch;

  static Future<Map<String, dynamic>> onlineSearchMulti(String query, [int offset = 1]) async {
    String url = "https://api.themoviedb.org/3/search/multi?api_key=$key&language=$lang&page=$offset&include_adult=false&query=$query";

    Map<String, dynamic> returner;  
    if (actualQuerySearch != null) {
    
      actualQuerySearch.timeout(Duration(microseconds: 0)).catchError((onError) {print("");});
    }
    actualQuerySearch = GlobalsFunc.fetchData(url).catchError((onError) => returner = Map.from({"error": GlobalsMessage.defaultError}));
    Response response;
    bool error = false;
    try {
      response = await actualQuerySearch;
    } on TypeError catch(e) {
      error = true;
      print("Erreur du turfu qui vient trs de je ne sais où");
    }
    actualQuerySearch = null;
    if (!error && response.statusCode == 200) {
      returner = jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      // GlobalsFunc.snackBar(context, GlobalsMessage.defaultError);
      returner = Map.from({
        "error": GlobalsMessage.defaultError,
      });
    }
    return TMDBQueries.sortNoContent(returner, QueryTypes.all);
  }

  static Future<Map<String, dynamic>> onlineSearchMovie(String query, [int offset = 1]) async {
    String url = "https://api.themoviedb.org/3/search/movie?api_key=$key&page=$offset&language=$lang&include_adult=false&query=$query";
      
    Map<String, dynamic> returner;
    if (actualQuerySearch != null) {
      actualQuerySearch.timeout(Duration(microseconds: 0)).catchError((onError) {print("");});
    }
    actualQuerySearch = GlobalsFunc.fetchData(url).catchError((onError) => returner = Map.from({"error": GlobalsMessage.defaultError}));
    Response response;
    bool error = false;
    try {
      response = await actualQuerySearch;
    } on TypeError catch(e) {
      error = true;
      print("Erreur du turfu qui vient trs de je ne sais où");
    }
    actualQuerySearch = null;
    if (!error && response.statusCode == 200) {
      returner = jsonDecode(response.body);
    } else {
      // GlobalsFunc.snackBar(context, GlobalsMessage.defaultError);
      returner = Map.from({
        "error": GlobalsMessage.defaultError,
      });
    }
    return TMDBQueries.sortNoContent(returner, QueryTypes.movie);
  }

  static Future<Map<String, dynamic>> onlineSearchPerson(String query, [int offset = 1]) async {
    String url = "https://api.themoviedb.org/3/search/person?api_key=$key&language=$lang&query=$query&page=$offset";

    Map<String, dynamic> returner;      
    if (actualQuerySearch != null) {
      actualQuerySearch.timeout(Duration(microseconds: 0)).catchError((onError) {print("");});
    }
    actualQuerySearch = GlobalsFunc.fetchData(url).catchError((onError) => returner = Map.from({"error": GlobalsMessage.defaultError}));
    Response response;
    bool error = false;
    try {
      response = await actualQuerySearch;
    } on TypeError catch(e) {
      error = true;
      print("Erreur du turfu qui vient trs de je ne sais où");
    }
    actualQuerySearch = null;
    if (!error && response.statusCode == 200) {
      returner = jsonDecode(response.body);
    } else {
      // GlobalsFunc.snackBar(context, GlobalsMessage.defaultError);
      returner = Map.from({
        "error": GlobalsMessage.defaultError,
      });
    }
    return TMDBQueries.sortNoContent(returner, QueryTypes.person);
  }

  static Future<Map<String, dynamic>> onlineSearchCollection(String query, [int offset = 1]) async {
    String url = "https://api.themoviedb.org/3/search/collection?api_key=$key&language=$lang&query=$query&page=$offset";

    Map<String, dynamic> returner;      
    if (actualQuerySearch != null) {
      actualQuerySearch.timeout(Duration(microseconds: 0)).catchError((onError) {print("");});
    }
    actualQuerySearch = GlobalsFunc.fetchData(url).catchError((onError) => returner = Map.from({"error": GlobalsMessage.defaultError}));
    Response response;
    bool error = false;
    try {
      response = await actualQuerySearch;
    } on TypeError catch(e) {
      error = true;
      print("Erreur du turfu qui vient trs de je ne sais où");
    }
    actualQuerySearch = null;
    if (!error && response.statusCode == 200) {
      returner = jsonDecode(response.body);
    } else {
      // GlobalsFunc.snackBar(context, GlobalsMessage.defaultError);
      returner = Map.from({
        "error": GlobalsMessage.defaultError,
      });
    }
    return TMDBQueries.sortNoContent(returner, QueryTypes.collection);
  }

  static Future<Map<String, dynamic>> onlineSearchTV(String query, [int offset = 1]) async {
    String url = "https://api.themoviedb.org/3/search/tv?api_key=$key&page=$offset&$lang&query=$query";

    Map<String, dynamic> returner;    
    if (actualQuerySearch != null) {
      actualQuerySearch.timeout(Duration(microseconds: 0)).catchError((onError) {print("");});
    }
    actualQuerySearch = GlobalsFunc.fetchData(url).catchError((onError) => returner = Map.from({"error": GlobalsMessage.defaultError}));
    Response response;
    bool error = false;
    try {
      response = await actualQuerySearch;
    } on TypeError catch(e) {
      error = true;
      print("Erreur du turfu qui vient trs de je ne sais où");
    }
    actualQuerySearch = null;
    if (!error && response.statusCode == 200) {
      returner = jsonDecode(response.body);
    } else {
      // GlobalsFunc.snackBar(context, GlobalsMessage.defaultError);
      returner = Map.from({
        "error": GlobalsMessage.defaultError,
      });
    }
    return TMDBQueries.sortNoContent(returner, QueryTypes.tv);
  }

  static Future<Map<String, dynamic>> onlineSearchCompanies(String query, [int offset = 1]) async {
    String url = "https://api.themoviedb.org/3/search/company?api_key=$key&page=$offset&$lang&query=$query";

    Map<String, dynamic> returner;    
    if (actualQuerySearch != null) {
      actualQuerySearch.timeout(Duration(microseconds: 0)).catchError((onError) {print("");});
    }
    actualQuerySearch = GlobalsFunc.fetchData(url).catchError((onError) => returner = Map.from({"error": GlobalsMessage.defaultError}));
    Response response;
    bool error = false;
    try {
      response = await actualQuerySearch;
    } on TypeError catch(e) {
      error = true;
      print("Erreur du turfu qui vient trs de je ne sais où");
    }
    actualQuerySearch = null;
    if (!error && response.statusCode == 200) {
      returner = jsonDecode(response.body);
    } else {
      // GlobalsFunc.snackBar(context, GlobalsMessage.defaultError);
      returner = Map.from({
        "error": GlobalsMessage.defaultError,
      });
    }
    return TMDBQueries.sortNoContent(returner, QueryTypes.companies);
  }

  static Future<Map<String, dynamic>> getMovie(String id) async {
    String url  = "https://api.themoviedb.org/3/movie/$id?api_key=$key&language=$lang";

    Map<String, dynamic> returner;
    Future<Response> queryFuture;
    queryFuture = GlobalsFunc.fetchData(url).catchError((onError) => returner = Map.from({"error": GlobalsMessage.defaultError}));
    Response response;
    bool error = false;
    try {
      response = await queryFuture;
    } on TypeError catch(e) {
      error = true;
      print("Erreur qui vient de je ne sais où");
    }
    if (!error && response.statusCode == 200) {
      returner = jsonDecode(response.body);
    } else {
      returner = Map.from({
        "error": GlobalsMessage.defaultError,
      });
    }
    return returner;
  }

  static Future<Map<String, dynamic>> getPerson(String id) async {
    String url = "https://api.themoviedb.org/3/person/$id?api_key=$key&language=$lang";

    Map<String, dynamic> returner;
    Future<Response> queryFuture;
    queryFuture = GlobalsFunc.fetchData(url).catchError((onError) => returner = Map.from({"error": GlobalsMessage.defaultError}));
    Response response;
    bool error = false;
    try {
      response = await queryFuture;
    } on TypeError catch(e) {
      error = true;
      print("Erreur qui vient de je ne sais où");
    }
    if (!error && response.statusCode == 200) {
      returner = jsonDecode(response.body);
    } else {
      returner = Map.from({
        "error": GlobalsMessage.defaultError,
      });
    }
    return returner;
  }

  static Future<Map<String, dynamic>> getTagList() async {
    String url = "https://api.themoviedb.org/3/genre/movie/list?api_key=$key&language=$lang";

    Map<String, dynamic> returner;
    Future<Response> queryFuture;
    queryFuture = GlobalsFunc.fetchData(url).catchError((onError) => returner = Map.from({"error": GlobalsMessage.defaultError}));
    Response response;
    bool error = false;
    try {
      response = await queryFuture;
    } on TypeError catch(e) {
      error = true;
      print("Erreur qui vient de je ne sais où");
    }
    if (!error && response.statusCode == 200) {
      returner = jsonDecode(response.body);
    } else {
      returner = Map.from({
        "error": GlobalsMessage.defaultError,
      });
    }
    return returner;
  }

  static Future<Map<String, dynamic>> getMovieCredits(String id) async {
    String url = "https://api.themoviedb.org/3/movie/$id/credits?api_key=$key";

    Map<String, dynamic> returner;
    Future<Response> queryFuture;
    queryFuture = GlobalsFunc.fetchData(url).catchError((onError) => returner = Map.from({"error": GlobalsMessage.defaultError}));
    Response response;
    bool error = false;
    try {
      response = await queryFuture;
    } on TypeError catch(e) {
      error = true;
      print("Erreur qui vient de je ne sais où"); 
    }
    if (!error && response.statusCode == 200) {
      returner = jsonDecode(response.body);
    } else {
      returner = Map.from({
        "error": GlobalsMessage.defaultError,
      });
    }
    return returner;
  }

  static Future<Map<String, dynamic>> getMovieSimilar(String id) async {
     String url = "https://api.themoviedb.org/3/movie/$id/similar?api_key=$key";

    Map<String, dynamic> returner;
    Future<Response> queryFuture;
    queryFuture = GlobalsFunc.fetchData(url).catchError((onError) => returner = Map.from({"error": GlobalsMessage.defaultError}));
    Response response;
    bool error = false;
    try {
      response = await queryFuture;
    } on TypeError catch(e) {
      error = true;
      print("Erreur qui vient de je ne sais où");
    }
    if (!error && response.statusCode == 200) {
      returner = jsonDecode(response.body);
    } else {
      returner = Map.from({
        "error": GlobalsMessage.defaultError,
      });
    }
    return returner;
  }

  static Future<Map<String, dynamic>> getMovieTrailer(String id) async {
     String url = "https://api.themoviedb.org/3/movie/$id/videos?api_key=$key";

    Map<String, dynamic> returner;
    Future<Response> queryFuture;
    queryFuture = GlobalsFunc.fetchData(url).catchError((onError) => returner = Map.from({"error": GlobalsMessage.defaultError}));
    Response response;
    bool error = false;
    try {
      response = await queryFuture;
    } on TypeError catch(e) {
      error = true;
      print("Erreur qui vient de je ne sais où");
    }
    if (!error && response.statusCode == 200) {
      returner = jsonDecode(response.body);
    } else {
      returner = Map.from({
        "error": GlobalsMessage.defaultError,
      });
    }
    return returner;
  }

  static Future<Map<String, dynamic>> getDiscover() async {

  }

  static Map<String, dynamic> sortNoContent(Map<String, dynamic> toSort, QueryTypes queryTypes) {
    List<dynamic> toRemove = [];
    if (toSort["results"] == null)
      return toSort;
    for (var value in toSort["results"]) {
      String mediaType = value["media_type"] == null ? GlobalsMessage.chipData[QueryTypes.values.indexOf(queryTypes)]["route"] : value["media_type"];
      // print(mediaType);
      if ((mediaType == "movie" && value["overview"].length < 3) 
      || (mediaType == "movie" && value["poster_path"] == null)
      || (mediaType == "person" && value["profile_path"] == null)) {
        toRemove.add(value);
      }
    }
    for (var value in toRemove)
      toSort["results"].remove(value);

    return toSort;
  }
}

enum QueryTypes {
  all,
  movie,
  person,
  tv,
  collection,
  companies
}
enum SortingTypes {
  alpha,
  date,
  defaul,
}