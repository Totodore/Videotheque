import 'dart:convert';
import 'package:http/http.dart';
import 'package:Videotheque/globals.dart';

class TMDBQueries {

  static const String key = GlobalsData.apiKey;
  static const String lang = GlobalsData.lang; 

  static Future<Response> actualQuerySearch;

  static Future<Map<String, dynamic>> onlineSearchMulti(String query, [SortingTypes sort = SortingTypes.date]) async {
    String url = "https://api.themoviedb.org/3/search/multi?api_key=$key&language=$lang&page=1&include_adult=false&query=$query";

    Map<String, dynamic> returner;  
    if (actualQuerySearch != null) {
      print("remove Query search");
      actualQuerySearch.timeout(Duration(microseconds: 0)).catchError((onError) => print("removed"));
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

  static Future<Map<String, dynamic>> onlineSearchMovie(String query, [int year = 0, SortingTypes sort = SortingTypes.date]) async {
    String url;
    if (year != 0)
      url = "https://api.themoviedb.org/3/search/movie?api_key=$key&language=$lang&year=$year&include_adult=false&query=$query";
    else 
      url = "https://api.themoviedb.org/3/search/movie?api_key=$key&language=$lang&include_adult=false&query=$query";
      

    Map<String, dynamic> returner;
    if (actualQuerySearch != null) {
      print("remove Query search");
      actualQuerySearch.timeout(Duration(microseconds: 0)).catchError((onError) => print("removed"));
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

  static Future<Map<String, dynamic>> onlineSearchPerson(String query, [SortingTypes sort = SortingTypes.date]) async {
    String url = "https://api.themoviedb.org/3/search/person?api_key=$key&language=$lang&query=$query";

    Map<String, dynamic> returner;      
    if (actualQuerySearch != null) {
      print("remove Query search");
      actualQuerySearch.timeout(Duration(microseconds: 0)).catchError((onError) => print("removed"));
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

  static Future<Map<String, dynamic>> onlineSearchCollection(String query, [SortingTypes sort = SortingTypes.date]) async {
    String url = "https://api.themoviedb.org/3/search/collection?api_key=$key&language=$lang&query=$query";

    Map<String, dynamic> returner;      
    if (actualQuerySearch != null) {
      print("remove Query search");
      actualQuerySearch.timeout(Duration(microseconds: 0)).catchError((onError) => print("removed"));
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

  static Future<Map<String, dynamic>> onlineSearchTV(String query, [int year = 0, SortingTypes sort = SortingTypes.date]) async {
    String url;
    if (year != 0)
      url = "https://api.themoviedb.org/3/search/tv?api_key=$key&language=$lang&query=$query&first_air_date_year=$year";
    else 
      url = "https://api.themoviedb.org/3/search/tv?api_key=$key&language=$lang&query=$query";

    Map<String, dynamic> returner;    
    if (actualQuerySearch != null) {
      print("remove Query search");
      actualQuerySearch.timeout(Duration(microseconds: 0)).catchError((onError) => print("removed"));
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

  static Future<Map<String, dynamic>> onlineSearchCompanies(String query, [SortingTypes sort = SortingTypes.date]) async {
    String url = "https://api.themoviedb.org/3/search/company?api_key=$key&language=$lang&query=$query";

    Map<String, dynamic> returner;    
    if (actualQuerySearch != null) {
      print("remove Query search");
      actualQuerySearch.timeout(Duration(microseconds: 0)).catchError((onError) => print("removed"));
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
    if (actualQuerySearch != null) {
      print("remove Query search");
      actualQuerySearch.timeout(Duration(microseconds: 0)).catchError((onError) => print("removed"));
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

  static Future<Map<String, dynamic>> getPerson(String id) async {
    String url = "https://api.themoviedb.org/3/person/$id?api_key=$key&language=$lang";

    Map<String, dynamic> returner;
    if (actualQuerySearch != null) {
      print("remove Query search");
      actualQuerySearch.timeout(Duration(microseconds: 0)).catchError((onError) => print("removed"));
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

  static Future<Map<String, dynamic>> getTagList() async {
    String url = "https://api.themoviedb.org/3/genre/movie/list?api_key=$key&language=$lang";

    Map<String, dynamic> returner;
    if (actualQuerySearch != null) {
      print("remove Query search");
      actualQuerySearch.timeout(Duration(microseconds: 0)).catchError((onError) => print("removed"));
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

  static Future<Map<String, dynamic>> getDiscover() async {

  }
}

enum QueryTypes {
  all,
  movie,
  person,
  collection,
  tv,
  companies
}
enum SortingTypes {
  alpha,
  date,
  defaul,
}