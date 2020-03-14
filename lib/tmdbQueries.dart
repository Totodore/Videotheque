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
    Response response = await actualQuerySearch;
    actualQuerySearch = null;
    if (response.statusCode == 200) {
      returner = jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      // GlobalsFunc.snackBar(context, GlobalsMessage.defaultError);
      returner = Map.from({
        "error": GlobalsMessage.defaultError,
      });
    }
    return returner;
  }

  static Future<Map<String, dynamic>> onlineSearchMovie(String query, [int offset = 1]) async {
    String url = "https://api.themoviedb.org/3/search/movie?api_key=$key&page=$offset&language=$lang&include_adult=false&query=$query";
      
    Map<String, dynamic> returner;
    if (actualQuerySearch != null) {
      actualQuerySearch.timeout(Duration(microseconds: 0)).catchError((onError) {print("");});
    }
    actualQuerySearch = GlobalsFunc.fetchData(url).catchError((onError) => returner = Map.from({"error": GlobalsMessage.defaultError}));
    Response response = await actualQuerySearch;
    actualQuerySearch = null;
    if (response.statusCode == 200) {
      returner = jsonDecode(response.body);
    } else {
      // GlobalsFunc.snackBar(context, GlobalsMessage.defaultError);
      returner = Map.from({
        "error": GlobalsMessage.defaultError,
      });
    }
    return returner;
  }

  static Future<Map<String, dynamic>> onlineSearchPerson(String query, [int offset = 1]) async {
    String url = "https://api.themoviedb.org/3/search/person?api_key=$key&language=$lang&query=$query&page=$offset";

    Map<String, dynamic> returner;      
    if (actualQuerySearch != null) {
      actualQuerySearch.timeout(Duration(microseconds: 0)).catchError((onError) {print("");});
    }
    actualQuerySearch = GlobalsFunc.fetchData(url).catchError((onError) => returner = Map.from({"error": GlobalsMessage.defaultError}));
    Response response = await actualQuerySearch;
    actualQuerySearch = null;
    if (response.statusCode == 200) {
      returner = jsonDecode(response.body);
    } else {
      // GlobalsFunc.snackBar(context, GlobalsMessage.defaultError);
      returner = Map.from({
        "error": GlobalsMessage.defaultError,
      });
    }
    return returner;
  }

  static Future<Map<String, dynamic>> onlineSearchCollection(String query, [int offset = 1]) async {
    String url = "https://api.themoviedb.org/3/search/collection?api_key=$key&language=$lang&query=$query&page=$offset";

    Map<String, dynamic> returner;      
    if (actualQuerySearch != null) {
      actualQuerySearch.timeout(Duration(microseconds: 0)).catchError((onError) {print("");});
    }
    actualQuerySearch = GlobalsFunc.fetchData(url).catchError((onError) => returner = Map.from({"error": GlobalsMessage.defaultError}));
    Response response = await actualQuerySearch;
    actualQuerySearch = null;
    if (response.statusCode == 200) {
      returner = jsonDecode(response.body);
    } else {
      // GlobalsFunc.snackBar(context, GlobalsMessage.defaultError);
      returner = Map.from({
        "error": GlobalsMessage.defaultError,
      });
    }
    return returner;
  }

  static Future<Map<String, dynamic>> onlineSearchTV(String query, [int offset = 1]) async {
    String url = "https://api.themoviedb.org/3/search/tv?api_key=$key&page=$offset&$lang&query=$query";

    Map<String, dynamic> returner;    
    if (actualQuerySearch != null) {
      actualQuerySearch.timeout(Duration(microseconds: 0)).catchError((onError) {print("");});
    }
    actualQuerySearch = GlobalsFunc.fetchData(url).catchError((onError) => returner = Map.from({"error": GlobalsMessage.defaultError}));
    Response response = await actualQuerySearch;
    actualQuerySearch = null;
    if (response.statusCode == 200) {
      returner = jsonDecode(response.body);
    } else {
      // GlobalsFunc.snackBar(context, GlobalsMessage.defaultError);
      returner = Map.from({
        "error": GlobalsMessage.defaultError,
      });
    }
    return returner;
  }

  static Future<Map<String, dynamic>> onlineSearchCompanies(String query, [int offset = 1]) async {
    String url = "https://api.themoviedb.org/3/search/company?api_key=$key&page=$offset&$lang&query=$query";

    Map<String, dynamic> returner;    
    if (actualQuerySearch != null) {
      actualQuerySearch.timeout(Duration(microseconds: 0)).catchError((onError) {print("");});
    }
    actualQuerySearch = GlobalsFunc.fetchData(url).catchError((onError) => returner = Map.from({"error": GlobalsMessage.defaultError}));
    Response response = await actualQuerySearch;
    actualQuerySearch = null;
    if (response.statusCode == 200) {
      returner = jsonDecode(response.body);
    } else {
      // GlobalsFunc.snackBar(context, GlobalsMessage.defaultError);
      returner = Map.from({
        "error": GlobalsMessage.defaultError,
      });
    }
    return returner;
  }

  static Future<Map<String, dynamic>> getMovie(String id) async {
    String url  = "https://api.themoviedb.org/3/movie/$id?api_key=$key&language=$lang";

    Map<String, dynamic> returner;
    Future<Response> queryFuture;
    queryFuture = GlobalsFunc.fetchData(url).catchError((onError) => returner = Map.from({"error": GlobalsMessage.defaultError}));
    Response response = await queryFuture;
    if (response.statusCode == 200) {
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
    Response response = await queryFuture;
    if (response.statusCode == 200) {
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
    Response response = await queryFuture;
    if (response.statusCode == 200) {
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
    Response response = await queryFuture;
    if (response.statusCode == 200) {
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
    Response response = await queryFuture;
    if (response.statusCode == 200) {
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
    Response response = await queryFuture;
    if (response.statusCode == 200) {
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