import 'package:Videotheque/api/firestoreQueries.dart';
import 'package:Videotheque/components/alert_dialog_component.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/api/tmdbQueries.dart';
import 'package:Videotheque/views/tv_view/season_view.dart';
import 'package:Videotheque/views/tv_view/tv_view.dart';
import 'package:flutter/material.dart';
import 'package:Videotheque/views/tv_view/addtag_view.dart';

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
    return id = await FirestoreQueries.getIdFromDbId(QueryTypes.tv, preloadData["id"].toString());
  }

  void fetchDbStats() async {
    isAdded = true;
    isToSee = await FirestoreQueries.isElementToSee(QueryTypes.tv, id);
    isSeen = await FirestoreQueries.isElementSeen(QueryTypes.tv, id);
    isFav = await FirestoreQueries.isElementFav(QueryTypes.tv, id);
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

    Map data = await TMDBQueries.getTv(preloadData["id"].toString());
    loadedInfosTags = [
      preloadData["vote_average"] != null && preloadData["vote_average"] > 0 ? preloadData["vote_average"].toString() + " ★" : null,
      data["in_production"] != null ? data["in_production"] ? "En production" :  "Terminée" : null,
      data["number_of_seasons"] != null ? "${data["number_of_seasons"]} saisons"  : null,
      data["number_of_episodes"] != null ? "${data["number_of_episodes"]} épisodes" : null
    ];
    loadedInfosTags.removeWhere((el) => el == null);

    if (data["created_by"] != null)
      data["created_by"].removeWhere((el) => el["profile_path"] == null);

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
    for (Map genre in Map.from(await TMDBQueries.getTagListTv())["genres"]) {
      for (int genre_id in preloadData["genre_ids"]) {
        if (genre["id"] == genre_id)
          loadedGenreTags.add(genre);
      }
    }
    if (id != null)
      addedGenreTags = await FirestoreQueries.getElementTags(QueryTypes.tv, id);
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
    Map data = await TMDBQueries.getTvCredits(preloadData["id"].toString());
    data["cast"].removeWhere((element) => element["profile_path"] == null);
    data["crew"].removeWhere((element) => element["profile_path"] == null);
    carrouselData[ElementsTypes.CastingCarrousel] = data["cast"];
    carrouselData[ElementsTypes.CrewCarrousel] = data["crew"];
    objectsStates[ElementsTypes.CastingCarrousel] = data["cast"] != null && data["cast"].length > 0 ? States.Added : States.Empty;
    objectsStates[ElementsTypes.CrewCarrousel] = data["crew"] != null && data["crew"].length > 0 ? States.Added : States.Empty;
    notifyListeners();
  }

  void fetchSimilarTv() async {
    objectsStates[ElementsTypes.SimilarCarrousel] = States.Loading;
    notifyListeners();
    List data = TMDBQueries.sortByPopularity(Map.from(await TMDBQueries.getTvSimilar(preloadData["id"].toString()))["results"]);
    data.removeWhere((element) => element["poster_path"] == null);
    carrouselData[ElementsTypes.SimilarCarrousel] = data;
    objectsStates[ElementsTypes.SimilarCarrousel] = data != null && data.length > 0 ? States.Added : States.Empty;
    notifyListeners();
  }

  void addTv() async {
    id = await FirestoreQueries.addElement(QueryTypes.tv, preloadData);
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
          if (await FirestoreQueries.removeElement(QueryTypes.tv, id)) {
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
      if (await FirestoreQueries.setElementToSee(QueryTypes.tv, id, true)) {
        Scaffold.of(scaffoldContext).showSnackBar(SnackBar(content: Text('${preloadData["name"]} ajouté aux séries à voir')));
        isToSee = true;
      }
    }
    else {
      if (await FirestoreQueries.setElementToSee(QueryTypes.tv, id, false)) {
        Scaffold.of(scaffoldContext).showSnackBar(SnackBar(content: Text('${preloadData["name"]} retiré des séries à voir')));
        isToSee = false;
      }
    }
    notifyListeners();
  }

  void onMovieSeenTapped(BuildContext scaffoldContext) async {
    Scaffold.of(scaffoldContext).hideCurrentSnackBar();
    if (!isSeen) {
      if (await FirestoreQueries.setElementSeen(QueryTypes.tv, id, true)) {
        Scaffold.of(scaffoldContext).showSnackBar(SnackBar(content: Text('${preloadData["name"]} ajouté aux séries vues')));
        isSeen = true;
      }
    }
    else {
      if (await FirestoreQueries.setElementSeen(QueryTypes.tv, id, false)) {
        Scaffold.of(scaffoldContext).showSnackBar(SnackBar(content: Text('${preloadData["name"]} retiré des séries vues')));
        isSeen = false;
      }
    }
    notifyListeners();

  }

  void onFavTapped(BuildContext scaffoldContext) async {
    Scaffold.of(scaffoldContext).hideCurrentSnackBar();
    if (!isFav) {
      if (await FirestoreQueries.setElementFav(QueryTypes.tv, id, true)) {
        Scaffold.of(scaffoldContext).showSnackBar(SnackBar(content: Text('${preloadData["name"]} ajouté aux favoris')));
        isFav = true;
      }
    }
    else {
      if (await FirestoreQueries.setElementFav(QueryTypes.tv, id, false)) {
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
    addedGenreTags = await FirestoreQueries.updateElementTags(QueryTypes.tv, newTags, id) ?? addedGenreTags;
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