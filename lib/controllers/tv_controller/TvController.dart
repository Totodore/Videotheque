import 'package:Videotheque/services/FireauthQueries.dart';
import 'package:Videotheque/services/FireconfigQueries.dart';
import 'package:Videotheque/services/FirestoreQueries.dart';
import 'package:Videotheque/components/AlertDialogComponent.dart';
import 'package:Videotheque/Globals.dart';
import 'package:Videotheque/services/TmdbQueries.dart';
import 'package:Videotheque/utils/Singletons.dart';
import 'package:Videotheque/views/tv_view/SeasonView.dart';
import 'package:Videotheque/views/tv_view/TvView.dart';
import 'package:flutter/material.dart';
import 'package:Videotheque/views/tv_view/AddTagView.dart';

class TvController extends ChangeNotifier {
  String heroTag;
  BuildContext context;
  String id;

  Map<ElementsTypes, States> objectsStates = Map.fromIterables(ElementsTypes.values, List.generate(ElementsTypes.values.length, (int index) => States.Nothing));
  Map<ElementsTypes, List> carrouselData = Map.fromIterables(ElementsTypes.values, List.generate(ElementsTypes.values.length, (int index) => []));

  Map preloadData;
  List loadedInfosTags = [];
  List loadedGenreTags = [];
  List addedGenreTags = [];
  String trailerKey = "";
  bool isAdded = false;
  bool isFav = false;
  bool isToSee = false;
  bool isSeen = false;
  BuildContext scaffoldContext;

  
  FireauthQueries fireauth = Singletons.instance<FireauthQueries>();
  FirestoreQueries firestore = Singletons.instance<FirestoreQueries>();
  FireconfigQueries fireconfig = Singletons.instance<FireconfigQueries>();
  TMDBQueries tmdbQueries = Singletons.instance<TMDBQueries>();


  TvController(this.context) {
    heroTag = GlobalsArgs.transfertArg[1];
    preloadData = GlobalsArgs.transfertArg[0];
    if (GlobalsArgs.isFromLibrary ?? false)
      convertDataToDBData();

    fetchDbId().then((id) {
      if (id != null) {
        fetchDbStats();
        // fetchGenreTags();
      }
      fetchDetails();
      fetchGenreTags();
      fetchPeopleCarrousels();
      fetchSimilarTv();
    });
  }

  void convertDataToDBData() {
    preloadData["poster_path"] = preloadData["image_url"];
    preloadData["genre_ids"] = preloadData["base_tags"];
    preloadData["id"] = preloadData["base_id"];
    preloadData["backdrop_path"] = preloadData["backdrop_url"];
    preloadData["name"] = preloadData["title"];
  }

  
  Future fetchDbId() async {
    return id = await firestore.getIdFromDbId(QueryTypes.tv, preloadData["id"].toString());
  }

  void fetchDbStats() async {
    isAdded = true;
    isToSee = await firestore.isElementToSee(QueryTypes.tv, id);
    isSeen = await firestore.isElementSeen(QueryTypes.tv, id);
    isFav = await firestore.isElementFav(QueryTypes.tv, id);
    notifyListeners();
  }
  void clearDbStats() {
    isAdded = false;
    isToSee = false;
    isSeen = false;
    isFav = false;
  }

  void fetchDetails() async {
    objectsStates[ElementsTypes.SeasonsCarrousel] = States.Loading;
    objectsStates[ElementsTypes.InfoTags] = States.Loading;   
    objectsStates[ElementsTypes.MadeByCarrousel] = States.Loading;   
    notifyListeners();

    Map data = await tmdbQueries.getTv(preloadData["id"].toString());
    loadedInfosTags = [
      preloadData["vote_average"] != null && preloadData["vote_average"] > 0 ? preloadData["vote_average"].toString() + " ★" : null,
      data["in_production"] != null ? data["in_production"] ? "En production" :  "Terminée" : null,
      data["number_of_seasons"] != null ? "${data["number_of_seasons"]} saisons"  : null,
      data["number_of_episodes"] != null ? "${data["number_of_episodes"]} épisodes" : null
    ];
    loadedInfosTags.removeWhere((el) => el == null);

    for (Map season in data["seasons"])
      if (season["poster_path"] == null) season["poster_path"] = preloadData["poster_path"];

    data["seasons"].sort((var el1, var el2) => el1["season_number"] < el2["season_number"] ? -1 : 1);
    carrouselData[ElementsTypes.SeasonsCarrousel] = data["seasons"];
    carrouselData[ElementsTypes.MadeByCarrousel] = data["created_by"];

    objectsStates[ElementsTypes.InfoTags] = loadedInfosTags.length > 0 ? States.Added : States.Empty;
    objectsStates[ElementsTypes.SeasonsCarrousel] = data["seasons"] != null && data["seasons"].length > 0 ? States.Added : States.Empty;
    objectsStates[ElementsTypes.MadeByCarrousel] = data["created_by"] != null && data["created_by"].length > 0 ? States.Added : States.Empty;


    notifyListeners();
  }

  void fetchGenreTags() async {
    objectsStates[ElementsTypes.GenreTags] = States.Loading;
    notifyListeners();
    for (Map genre in Map.from(await tmdbQueries.getTagListTv())["genres"]) {
      for (int genre_id in preloadData["genre_ids"]) {
        if (genre["id"] == genre_id)
          loadedGenreTags.add(genre);
      }
    }
    if (id != null)
      addedGenreTags = await firestore.getElementTags(QueryTypes.tv, id);
    objectsStates[ElementsTypes.GenreTags] = List.from(List.from(loadedGenreTags)..addAll(addedGenreTags)).length > 0 ? States.Added : States.Empty;
    notifyListeners();
  }

  bool dispElement(ElementsTypes element) {
    if (objectsStates[element] == States.Loading || objectsStates[element] == States.Added)
      return true;
    else return false;
  }

  void fetchPeopleCarrousels() async {
    objectsStates[ElementsTypes.CastingCarrousel] = States.Loading;
    objectsStates[ElementsTypes.CrewCarrousel] = States.Loading;
    notifyListeners();
    Map data = await tmdbQueries.getTvCredits(preloadData["id"].toString());
    carrouselData[ElementsTypes.CastingCarrousel] = data["cast"];
    carrouselData[ElementsTypes.CrewCarrousel] = data["crew"];
    objectsStates[ElementsTypes.CastingCarrousel] = data["cast"] != null && data["cast"].length > 0 ? States.Added : States.Empty;
    objectsStates[ElementsTypes.CrewCarrousel] = data["crew"] != null && data["crew"].length > 0 ? States.Added : States.Empty;
    notifyListeners();
  }

  void fetchSimilarTv() async {
    objectsStates[ElementsTypes.SimilarCarrousel] = States.Loading;
    notifyListeners();
    List data = tmdbQueries.sortByPopularity(Map.from(await tmdbQueries.getTvSimilar(preloadData["id"].toString()))["results"]);
    data.removeWhere((element) => element["poster_path"] == null);
    carrouselData[ElementsTypes.SimilarCarrousel] = data;
    objectsStates[ElementsTypes.SimilarCarrousel] = data != null && data.length > 0 ? States.Added : States.Empty;
    notifyListeners();
  }

  void addTv() async {
    id = await firestore.addElement(QueryTypes.tv, preloadData);
    if (id != null) {
      isAdded = true;
    }
    notifyListeners();
  }

  void removeTv() {
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialogComponent(
        content: "Êtes-vous sur de supprimer cette série de votre vidéothèque ?",
        onConfirmed: () async {  //On confirm
          if (await firestore.removeElement(QueryTypes.tv, id)) {
            clearDbStats();
            notifyListeners();
          }
          Navigator.pop(context);
        }, 
        onAbort: () { //On abort
          Navigator.pop(context);
        }, 
        mainColor: TvView.baseColor
      );
    });
  }

  void onTvToSeeTapped(BuildContext scaffoldContext) async {
    Scaffold.of(scaffoldContext).hideCurrentSnackBar();
    if (!isToSee) {
      if (await firestore.setElementToSee(QueryTypes.tv, id, true)) {
        Scaffold.of(scaffoldContext).showSnackBar(SnackBar(content: Text('${preloadData["name"]} ajouté aux séries à voir')));
        isToSee = true;
      }
    }
    else {
      if (await firestore.setElementToSee(QueryTypes.tv, id, false)) {
        Scaffold.of(scaffoldContext).showSnackBar(SnackBar(content: Text('${preloadData["name"]} retiré des séries à voir')));
        isToSee = false;
      }
    }
    notifyListeners();
  }

  void onTvSeenTapped(BuildContext scaffoldContext) async {
    Scaffold.of(scaffoldContext).hideCurrentSnackBar();
    if (!isSeen) {
      if (await firestore.setElementSeen(QueryTypes.tv, id, true)) {
        Scaffold.of(scaffoldContext).showSnackBar(SnackBar(content: Text('${preloadData["name"]} ajouté aux séries vues')));
        isSeen = true;
      }
    }
    else {
      if (await firestore.setElementSeen(QueryTypes.tv, id, false)) {
        Scaffold.of(scaffoldContext).showSnackBar(SnackBar(content: Text('${preloadData["name"]} retiré des séries vues')));
        isSeen = false;
      }
    }
    notifyListeners();

  }

  void onFavTapped(BuildContext scaffoldContext) async {
    Scaffold.of(scaffoldContext).hideCurrentSnackBar();
    if (!isFav) {
      if (await firestore.setElementFav(QueryTypes.tv, id, true)) {
        Scaffold.of(scaffoldContext).showSnackBar(SnackBar(content: Text('${preloadData["name"]} ajouté aux favoris')));
        isFav = true;
      }
    }
    else {
      if (await firestore.setElementFav(QueryTypes.tv, id, false)) {
        isFav = false;
        Scaffold.of(scaffoldContext).showSnackBar(SnackBar(content: Text('${preloadData["name"]} retiré des favoris')));
      }
    }
    notifyListeners();
  }

  onAddTagTapped() {
    AddTagView actualBottomSheetView;
    showModalBottomSheet(
      context: scaffoldContext, 
      builder: (context) => actualBottomSheetView = AddTagView(context, List.from(addedGenreTags), this.applyTagsEdits),
      isScrollControlled: true,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
    ).then((void value) => applyTagsEdits(actualBottomSheetView.globalController.chips));
  }

  void applyTagsEdits(List newTags) async {
    objectsStates[ElementsTypes.GenreTags] = States.Loading;
    notifyListeners();
    addedGenreTags = await firestore.updateElementTags(QueryTypes.tv, newTags, id) ?? addedGenreTags;
    objectsStates[ElementsTypes.GenreTags] = States.Added;
    notifyListeners();
  }

  void showSeasonEl(int index, String heroTag) {
    showModalBottomSheet(
      context: scaffoldContext,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      barrierColor: Colors.black.withAlpha(1),
      builder: (context) => SeasonView(carrouselData[ElementsTypes.SeasonsCarrousel][index], heroTag, preloadData["id"].toString()),
    );
  }
}