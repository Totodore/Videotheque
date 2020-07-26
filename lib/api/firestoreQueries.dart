import 'package:Videotheque/api/FireauthQueries.dart';
import 'package:Videotheque/api/tmdbQueries.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class FirestoreQueries {
  //Effectue un transfert de données depuis la bdd en parametre vers firebase
  //On remplace les clef par des UUID et on met les id tmdb dans un nv champs
  static Future<bool> transferDb(Map db) async {
    try {
      String userId = await FireauthQueries.getUserId;
      List moviesValues = [];
      List peopleValues = [];
      for (String key in db["movie"].keys) {
        Map el = db["movie"][key];
        Map data = await TMDBQueries.getMovie(el["id"].toString());
        List baseTags = List.generate(data["genres"].length, (index) => data["genres"][index]["id"]);
        moviesValues.add({
          "base_id": el["id"],
          "creation_date": (el["date"]/1000).ceil(),
          "title": el["title"],
          "image_url": data["poster_path"],
          "added_tags": [],
          "popularity": data["popularity"] ?? 0,
          "base_tags": baseTags ?? [],
          "overview": data["overview"],
          "backdrop_url": data["backdrop_path"],
          "fav": false,
          "to_see": false,
          "seen": false,
          "type": "movie"
        });
      }
      for (String key in db["people"].keys) {
        Map el = db["people"][key];
        Map data = await TMDBQueries.getPerson(el["id"].toString());
        peopleValues.add({
          "base_id": el["id"],
          "creation_date": (el["date"]/1000).ceil(),
          "title": el["title"],
          "image_url": data["profile_path"],
          "added_tags": [],
          "popularity": data["popularity"] ?? 0,
          "base_tags": [],
          "overview": data["biography"],
          "fav": false,
          "to_see": false,
          "seen": false,
          "type": "person"
        });
      }
      await Firestore.instance.collection(userId).document("movies").setData(Map.fromIterables(
        List.generate(db["movie"].length, (index) => Uuid().v1()), 
        moviesValues
      ));
      await Firestore.instance.collection(userId).document("people").setData(Map.fromIterables(
        List.generate(db["people"].length, (index) => Uuid().v1()),
        peopleValues,
      ));
      await Firestore.instance.collection(userId).document("series").setData({});
      await Firestore.instance.collection(userId).document("collections").setData({});
      await Firestore.instance.collection(userId).document("tags").setData({});
      await Firestore.instance.collection(userId).document("metadata").setData({
        "data_transferred": true,
        "account_created": (DateTime.now().millisecondsSinceEpoch/1000).ceil()
      });
    } on Exception catch(e) {
      print(e);
      return false;
    }
    return true;
  }

  static Future<bool> initDb() async {
    try {
      String userId = await FireauthQueries.getUserId;
      await Firestore.instance.collection(userId).document("movies").setData({});
      await Firestore.instance.collection(userId).document("people").setData({});
      await Firestore.instance.collection(userId).document("series").setData({});
      await Firestore.instance.collection(userId).document("collections").setData({});
      await Firestore.instance.collection(userId).document("tags").setData({});
      await Firestore.instance.collection(userId).document("metadata").setData({
        "data_transferred": false,
        "account_created": (DateTime.now().millisecondsSinceEpoch/1000).ceil()
      });
    } on Exception catch(e) {
      print(e);
      return false;
    }
    return true;
  }

  //Ajoute un un element à la bdd
  static Future<String> addElement(QueryTypes elementType, Map data) async {
    String id = Uuid().v1();
    try {
      (await _getUserCollection).document(_dbRouteFromElement(elementType)).updateData({
        id: {
          "base_id": data["id"],
          "title": data["title"] ?? data["original_title"] ?? data["name"] ?? data["original_name"],
          "popularity": data["popularity"] ?? 0,
          "image_url": data["poster_path"] ?? data["profile_path"],
          "base_tags": data["genre_ids"] ?? [],
          "overview": data["overview"] ?? data["biography"],
          "added_tags": [],
          "creation_date": (DateTime.now().millisecondsSinceEpoch/1000).ceil(),
          "backdrop_url": data["backdrop_path"],
          "fav": false,
          "to_see": false,
          "seen": false,
          "type": EnumToString.parse(elementType)
        }
      });
    } on Exception catch(e) {
      print(e);
      return null;
    }
    return id;
  }
  static Future<bool> removeElement(QueryTypes elementType, String id) async {
    try {
      (await _getUserCollection).document(_dbRouteFromElement(elementType)).updateData({
        id: FieldValue.delete()
      });
    } on Exception catch(e) {
      print(e);
      return false;
    }
    return true;
  }

  static Future<bool> createTag(String id, String name) async {
    try {
      (await _getUserCollection).document("tags").updateData({id: name});
    } on Exception catch(e) {
      print(e);
      return false;
    }
    return true;
  }
  static Future<List> getElementTags(QueryTypes elementType, String id) async {
    try {
      Map globalTags = await getTags();
      if (globalTags == null) return null;

      List tagsIds = (await (await _getUserCollection).document(_dbRouteFromElement(elementType)).get()).data[id]["added_tags"];
      //On créé une List de map avec l'id et le nom
      return List.generate(tagsIds.length, (int index) => List.from(globalTags.keys).contains(tagsIds[index]) ? {
        "name": Utils.capitalize(globalTags[tagsIds[index]]), //Capitale sur la première lettre
        "id": tagsIds[index]
      } : null)..removeWhere((element) => element == null);
    } on Exception catch(e) {
      print(e);
      return null;
    }
  } 
  static Future<bool> removeTag(String id) async {
    try {
      (await _getUserCollection).document("tags").updateData({id: FieldValue.delete()});
    } on Exception catch(e) {
      print(e);
      return false;
    }
    return true;
  }
  static Future<List> updateElementTags(QueryTypes elementType, List tagsId, String elId) async {
    Map globalsTags = await getTags();
    List idToAdd = [];
    if (globalsTags == null) return null;  //SI on arrive pas à récup la liste des tags on retourne false
    for (Map inputTag in tagsId) {  //Pour chaque tag dans la liste globale on regarde ceux qui existent pas dans la liste spécifique et on les ajoutes
      bool exists = false;
      for (String key in globalsTags.keys) {
        if (globalsTags[key].toString().toLowerCase() == inputTag["name"].toString().toLowerCase()) {
          exists = true;
          idToAdd.add(key);
          break;
        }
      }
      if (!exists) {
        if (!await createTag(inputTag["id"], inputTag["name"].toString().toLowerCase())) return null;
        idToAdd.add(inputTag["id"]);
      }
    }
    try {
      (await _getUserCollection).document(_dbRouteFromElement(elementType)).updateData({
        "$elId.added_tags": idToAdd
      });
    } on Exception catch(e) {
      print(e);
      return null;
    }
    return getElementTags(elementType, elId);
  }
  static Future<Map> getTags() async {
    try {
      return (await (await _getUserCollection).document("tags").get()).data;
    } on Exception catch(e) {
      print(e);
      return null;
    }
  }
  static Future<String> getIdFromDbId(QueryTypes elementType, String db_id) async {
    String el =  (await _getElementFromBaseId(db_id, elementType)).length > 0 ? (await _getElementFromBaseId(db_id, elementType))[0] : null;
    return el;
  }
  //Renvoie si un element est ajouté en fonction de son id TMDB
  static Future<bool> isElementAdded(QueryTypes elementType, String db_id) async {
    return (await _getElementFromBaseId(db_id, elementType)).length > 0;
  }
  static Future<bool> isElementFav(QueryTypes elementType, String id) async {
    return (await (await _getUserCollection).document(_dbRouteFromElement(elementType)).get()).data[id]["fav"];
  }
  static Future<bool> isElementToSee(QueryTypes elementType, String id) async {
    return (await (await _getUserCollection).document(_dbRouteFromElement(elementType)).get()).data[id]["to_see"];
  }
  static Future<bool> isElementSeen(QueryTypes elementType, String id) async {
    return (await (await _getUserCollection).document(_dbRouteFromElement(elementType)).get()).data[id]["seen"];
  }
  static Future<bool> setElementFav(QueryTypes elementType, String id, bool state) async {
    try {
      await (await _getUserCollection).document(_dbRouteFromElement(elementType)).updateData({
        "$id.fav": state
      });
    } on Exception catch(e) {
      print(e);
      return false;
    }
    return true;
  }
  static Future<bool> setElementToSee(QueryTypes elementType, String id, bool state) async {
    try {
      await (await _getUserCollection).document(_dbRouteFromElement(elementType)).updateData({
        "$id.to_see": state
      });
    } on Exception catch(e) {
      print(e);
      return false;
    }
    return true;
  }
  static Future<bool> setElementSeen(QueryTypes elementType, String id, bool state) async {
    try {
      await (await _getUserCollection).document(_dbRouteFromElement(elementType)).updateData({
        "$id.seen": state
      });
    } on Exception catch(e) {
      print(e);
      return false;
    }
    return true;
  }
  //Ecoute les données de la bibliothèque qui arrivent
  static void setElementsListener(QueryTypes type, Function onData, [int limit = -1, int offset = 0]) async {
    Stream stream;
    try {  
      if (type != QueryTypes.all)
        stream = (await _getUserCollection).document(_dbRouteFromElement(type)).snapshots().skip(offset);
      else {
        List<QueryTypes> types = List.from(QueryTypes.values)..removeAt(0);
        stream = CombineLatestStream.list(await Future.wait(types.map((QueryTypes type) async {
          return (await _getUserCollection).document(_dbRouteFromElement(type)).snapshots();
        }))).skip(offset);
      }

      if (limit == -1)
        stream.listen(onData);
      else
        stream.take(limit).listen(onData);
    } on Exception catch(e) {
      print(e);
    }   
  }
  //Récupère les données de l'utilisateur courant
  static Future<CollectionReference> get _getUserCollection async => 
    Firestore.instance.collection(await FireauthQueries.getUserId);

  // Retrouve un element à partir de l'ID de TMDB et de son type
  static Future<List> _getElementFromBaseId(String baseId, QueryTypes element) async {
    Map data = (await (await _getUserCollection).document(_dbRouteFromElement(element)).get()).data;
    List returner = [];
    for (String key in data.keys) {
      if (data[key]["base_id"].toString() == baseId) {
        returner = [key, data[key]];
        break;
      }
    }
    return returner;
  }

  static Future<int> get getUserTimestamp async => (await (await _getUserCollection).document("metadata").get()).data["account_created"];

  // Récupère la route de la bdd à partir de l'élément
  static String _dbRouteFromElement(QueryTypes element) {
    return GlobalsMessage.chipData[QueryTypes.values.indexOf(element)]["db_route"];
  }

  static Future<int> statNumberEl(QueryTypes element) async {
    return (await (await _getUserCollection).document(_dbRouteFromElement(element)).get()).data.length;
  }

  static Future<int> get statNumberTags async {
    return (await (await _getUserCollection).document("tags").get()).data.length;
  }
    //[0] : Seen, [1] : To see, [2] : fav
  static Future<List> get statNumberGeneral async {
    Map movies = (await (await _getUserCollection).document("movies").get()).data;
    Map people = (await (await _getUserCollection).document("people").get()).data;
    Map tv = (await (await _getUserCollection).document("series").get()).data;
    Map collections = (await (await _getUserCollection).document("collections").get()).data;
    Map generalData = Map.from(movies)..addAll(people)..addAll(tv)..addAll(collections);
    List<int> stats = [0, 0, 0];
    for (var key in generalData.keys) {
      if (generalData[key]["seen"] ?? false) stats[0]++;
      if (generalData[key]["to_see"] ?? false) stats[1]++;
      if (generalData[key]["fav"] ?? false) stats[2]++;
    }
    return stats;
  }
}