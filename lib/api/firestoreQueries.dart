import 'package:Videotheque/api/FireauthQueries.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/utils/Singletons.dart';
import 'package:Videotheque/utils/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class FirestoreQueries {

  Future<bool> hasDB(String uid) async =>
      (await FirebaseFirestore.instance.collection(uid).get()).docs.length > 0;
  Future<bool> initDb() async {
    try {
      String userId = await Singletons.instance<FireauthQueries>().userId;
      print("User id : $userId");
      // FirebaseFirestore.instance.
      await FirebaseFirestore.instance.collection(userId).doc("movies").set({});
      await FirebaseFirestore.instance.collection(userId).doc("people").set({});
      await FirebaseFirestore.instance.collection(userId).doc("series").set({});
      await FirebaseFirestore.instance.collection(userId).doc("collections").set({});
      await FirebaseFirestore.instance.collection(userId).doc("tags").set({});
      await FirebaseFirestore.instance.collection(userId).doc("metadata").set({
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
  Future<String> addElement(QueryTypes elementType, Map data) async {
    String id = Uuid().v1();
    try {
      (await _getUserCollection).doc(_dbRouteFromElement(elementType)).update({
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
          "fav_timestamp": 0,
          "to_see": false,
          "to_see_timestamp": 0,
          "seen": false,
          "seen_timestamp": 0,
          "type": EnumToString.convertToString(elementType)
        }
      });
    } on Exception catch(e) {
      print(e);
      return null;
    }
    return id;
  }
  Future<bool> removeElement(QueryTypes elementType, String id) async {
    try {
      (await _getUserCollection).doc(_dbRouteFromElement(elementType)).update({
        id: FieldValue.delete()
      });
    } on Exception catch(e) {
      print(e);
      return false;
    }
    return true;
  }

  Future<bool> createTag(String id, String name) async {
    try {
      (await _getUserCollection).doc("tags").update({id: name});
    } on Exception catch(e) {
      print(e);
      return false;
    }
    return true;
  }
  Future<List> getElementTags(QueryTypes elementType, String id) async {
    try {
      Map globalTags = await getTags();
      if (globalTags == null) return null;

      List tagsIds = (await (await _getUserCollection).doc(_dbRouteFromElement(elementType)).get()).data()[id]["added_tags"];
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
  Future<bool> removeTag(String id) async {
    try {
      (await _getUserCollection).doc("tags").update({id: FieldValue.delete()});
    } on Exception catch(e) {
      print(e);
      return false;
    }
    return true;
  }
  Future<List> updateElementTags(QueryTypes elementType, List tagsId, String elId) async {
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
      (await _getUserCollection).doc(_dbRouteFromElement(elementType)).update({
        "$elId.added_tags": idToAdd
      });
    } on Exception catch(e) {
      print(e);
      return null;
    }
    return getElementTags(elementType, elId);
  }
  Future<Map> getTags() async {
    try {
      return (await (await _getUserCollection).doc("tags").get()).data();
    } on Exception catch(e) {
      print(e);
      return null;
    }
  }
  Future<String> getIdFromDbId(QueryTypes elementType, String dbID) async {
    String el =  (await _getElementFromBaseId(dbID, elementType)).length > 0 ? (await _getElementFromBaseId(dbID, elementType))[0] : null;
    return el;
  }
  //Renvoie si un element est ajouté en fonction de son id TMDB
  Future<bool> isElementAdded(QueryTypes elementType, String dbID) async {
    return (await _getElementFromBaseId(dbID, elementType)).length > 0;
  }
  Future<bool> isElementFav(QueryTypes elementType, String id) async {
    return (await (await _getUserCollection).doc(_dbRouteFromElement(elementType)).get()).data()[id]["fav"];
  }
  Future<bool> isElementToSee(QueryTypes elementType, String id) async {
    return (await (await _getUserCollection).doc(_dbRouteFromElement(elementType)).get()).data()[id]["to_see"];
  }
  Future<bool> isElementSeen(QueryTypes elementType, String id) async {
    return (await (await _getUserCollection).doc(_dbRouteFromElement(elementType)).get()).data()[id]["seen"];
  }
  Future<bool> setElementFav(QueryTypes elementType, String id, bool state) async {
    try {
      await (await _getUserCollection).doc(_dbRouteFromElement(elementType)).update({
        "$id.fav": state,
        "$id.fav_timestamp": Timestamp.now().seconds
      });
    } on Exception catch(e) {
      print(e);
      return false;
    }
    return true;
  }
  Future<bool> setElementToSee(QueryTypes elementType, String id, bool state) async {
    try {
      await (await _getUserCollection).doc(_dbRouteFromElement(elementType)).update({
        "$id.to_see": state,
        "$id.to_see_timestamp": Timestamp.now().seconds
      });
    } on Exception catch(e) {
      print(e);
      return false;
    }
    return true;
  }
  Future<bool> setElementSeen(QueryTypes elementType, String id, bool state) async {
    try {
      await (await _getUserCollection).doc(_dbRouteFromElement(elementType)).update({
        "$id.seen": state,
        "$id.seen_timestamp": Timestamp.now().seconds
      });
    } on Exception catch(e) {
      print(e);
      return false;
    }
    return true;
  }
  //Ecoute les données de la bibliothèque qui arrivent
  void setElementsListener(QueryTypes type, Function onData, [int limit = -1, int offset = 0]) async {
    Stream stream;
    try {  
      if (type != QueryTypes.all)
        stream = (await _getUserCollection).doc(_dbRouteFromElement(type)).snapshots().skip(offset);
      else {
        List<QueryTypes> types = List.from(QueryTypes.values)..removeAt(0);
        stream = CombineLatestStream.list(await Future.wait(types.map((QueryTypes type) async {
          return (await _getUserCollection).doc(_dbRouteFromElement(type)).snapshots();
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
  Future<CollectionReference> get _getUserCollection async => 
    FirebaseFirestore.instance.collection(await Singletons.instance<FireauthQueries>().userId);

  // Retrouve un element à partir de l'ID de TMDB et de son type
  Future<List> _getElementFromBaseId(String baseId, QueryTypes element) async {
    Map data = (await (await _getUserCollection).doc(_dbRouteFromElement(element)).get()).data();
    List returner = [];
    for (String key in data.keys) {
      if (data[key]["base_id"].toString() == baseId) {
        returner = [key, data[key]];
        break;
      }
    }
    return returner;
  }

  Future<int> get getUserTimestamp async => (await (await _getUserCollection).doc("metadata").get()).data()["account_created"] ?? 0;

  // Récupère la route de la bdd à partir de l'élément
  String _dbRouteFromElement(QueryTypes element) {
    return GlobalsMessage.chipData[QueryTypes.values.indexOf(element)]["db_route"];
  }

  Future<int> statNumberEl(QueryTypes element) async {
    return (await (await _getUserCollection).doc(_dbRouteFromElement(element)).get()).data().length;
  }

  Future<int> get statNumberTags async {
    return (await (await _getUserCollection).doc("tags").get()).data().length;
  }
    //[0] : Seen, [1] : To see, [2] : fav
  Future<List> get statNumberGeneral async {
    Map movies = (await (await _getUserCollection).doc("movies").get()).data();
    Map people = (await (await _getUserCollection).doc("people").get()).data();
    Map tv = (await (await _getUserCollection).doc("series").get()).data();
    Map collections = (await (await _getUserCollection).doc("collections").get()).data();
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