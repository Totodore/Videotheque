import 'package:Videotheque/services/FireauthQueries.dart';
import 'package:Videotheque/services/FireconfigQueries.dart';
import 'package:Videotheque/services/FirestoreQueries.dart';
import 'package:Videotheque/components/AlertDialogComponent.dart';
import 'package:Videotheque/Globals.dart';
import 'package:Videotheque/services/TmdbQueries.dart';
import 'package:Videotheque/utils/Singletons.dart';
import 'package:Videotheque/views/movie_view/addtag_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MovieController extends ChangeNotifier {
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

  FireauthQueries fireauth = Singletons.instance<FireauthQueries>();
  FirestoreQueries firestore = Singletons.instance<FirestoreQueries>();
  FireconfigQueries fireconfig = Singletons.instance<FireconfigQueries>();
  TMDBQueries tmdbQueries = Singletons.instance<TMDBQueries>();


  MovieController(this.context) {
    heroTag = GlobalsArgs.transfertArg[1];
    preloadData = GlobalsArgs.transfertArg[0];
    print(preloadData);
    if (GlobalsArgs.isFromLibrary ?? false)
      convertDataToDBData();

    fetchDbId().then((id) {
      if (id != null) //Si le film est ajouté
        fetchDbStats();
      fetchInfosTags();
      fetchGenreTags();
      fetchPeopleCarrousels();
      fetchSimilarMovies();
      fetchTrailer();
    });

  }

  void convertDataToDBData() {
    preloadData["poster_path"] = preloadData["image_url"];
    preloadData["genre_ids"] = preloadData["base_tags"];
    preloadData["id"] = preloadData["base_id"];
    preloadData["backdrop_path"] = preloadData["backdrop_url"];
  }

  Future fetchDbId() async {
    return id = await firestore.getIdFromDbId(QueryTypes.movie, preloadData["id"].toString());
  }

  void fetchDbStats() async {
    isAdded = true;
    isToSee = await firestore.isElementToSee(QueryTypes.movie, id);
    isSeen = await firestore.isElementSeen(QueryTypes.movie, id);
    isFav = await firestore.isElementFav(QueryTypes.movie, id);
    notifyListeners();
  }
  void clearDbStats() {
    isAdded = false;
    isToSee = false;
    isSeen = false;
    isFav = false;
  }
  void fetchInfosTags() async {
    objectsStates[ElementsTypes.InfoTags] = States.Loading;
    notifyListeners();
    Map data = await tmdbQueries.getMovie(preloadData["id"].toString());
    DateTime date;
    try {
      date = DateTime.parse(data["release_date"]);
    } catch (e) {}
    loadedInfosTags = [
      date != null ? "Sortie : " + DateFormat('dd/MM/yyyy').format(date) : null,
      data["vote_average"] != null && data["vote_average"] > 0 ? "${data["vote_average"]} ★" : null,
      data["budget"] != null && data["budget"] > 0 ? "${data["budget"]} \$" : null,
      data["status"] != null ? data["status"] : null,
    ];
    loadedInfosTags.removeWhere((element) => element == null);
    objectsStates[ElementsTypes.InfoTags] = States.Added;
    notifyListeners();
  }

  void fetchGenreTags() async {
    objectsStates[ElementsTypes.GenreTags] = States.Loading;
    notifyListeners();
    for (Map genre in Map.from(await tmdbQueries.getTagListMovie())["genres"]) {
      for (int genre_id in preloadData["genre_ids"]) {
        if (genre["id"] == genre_id)
          loadedGenreTags.add(genre);
      }
    }
    if (id != null)
      addedGenreTags = await firestore.getElementTags(QueryTypes.movie, id);
    objectsStates[ElementsTypes.GenreTags] = List.from(List.from(loadedGenreTags)..addAll(addedGenreTags)).length > 0 ? States.Added : States.Empty;
    notifyListeners();
  }

  void fetchPeopleCarrousels() async {
    objectsStates[ElementsTypes.CastingCarrousel] = States.Loading;
    objectsStates[ElementsTypes.CrewCarrousel] = States.Loading;
    notifyListeners();
    Map data = await tmdbQueries.getMovieCredits(preloadData["id"].toString());
    carrouselData[ElementsTypes.CastingCarrousel] = data["cast"];
    carrouselData[ElementsTypes.CrewCarrousel] = data["crew"];
    objectsStates[ElementsTypes.CastingCarrousel] = carrouselData[ElementsTypes.CastingCarrousel].length > 0 ? States.Added : States.Empty;
    objectsStates[ElementsTypes.CrewCarrousel] = carrouselData[ElementsTypes.CrewCarrousel].length > 0 ? States.Added : States.Empty;
    notifyListeners();
  }
  void fetchSimilarMovies() async {
    objectsStates[ElementsTypes.SimilarCarrousel] = States.Loading;
    notifyListeners();
    List similars = tmdbQueries.sortByPopularity(Map.from(await tmdbQueries.getMovieSimilar(preloadData["id"].toString()))["results"]);
    carrouselData[ElementsTypes.SimilarCarrousel] = similars;
    objectsStates[ElementsTypes.SimilarCarrousel] = carrouselData[ElementsTypes.SimilarCarrousel] != null && carrouselData[ElementsTypes.SimilarCarrousel].length > 0 ? States.Added : States.Empty;
    notifyListeners();
  }

  void fetchTrailer() async {
    objectsStates[ElementsTypes.YoutubeTrailer] = States.Loading;
    notifyListeners();
    carrouselData[ElementsTypes.YoutubeTrailer] = Map.from(await tmdbQueries.getMovieTrailer(preloadData["id"].toString()))["results"];

    for (Map trailer in carrouselData[ElementsTypes.YoutubeTrailer]) {
      if (trailer["site"] == "YouTube") {
        trailerKey = trailer["key"];
        break;
      }
    }
    objectsStates[ElementsTypes.YoutubeTrailer] = trailerKey.length > 0 ? States.Added : States.Empty;
    notifyListeners();
  }
  
  void addMovie() async {
    id = await firestore.addElement(QueryTypes.movie, preloadData);
    if (id != null) {
      isAdded = true;
    }
    notifyListeners();
  }

  void removeMovie() {
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialogComponent(
        content: "Êtes-vous sur de supprimer ce film de votre vidéothèque ?",
        onConfirmed: () async {  //On confirm
          if (await firestore.removeElement(QueryTypes.movie, id)) {
            clearDbStats();
            notifyListeners();
          }
          Navigator.pop(context);
        }, 
        onAbort: () { //On abort
          Navigator.pop(context);
        }, 
        mainColor: GlobalsColor.darkGreen
      );
    });
  }

  void onMovieToSeeTapped(BuildContext scaffoldContext) async {
    Scaffold.of(scaffoldContext).hideCurrentSnackBar();
    if (!isToSee) {
      if (await firestore.setElementToSee(QueryTypes.movie, id, true)) {
        Scaffold.of(scaffoldContext).showSnackBar(SnackBar(content: Text('${preloadData["title"]} ajouté aux films à voir')));
        isToSee = true;
      }
    }
    else {
      if (await firestore.setElementToSee(QueryTypes.movie, id, false)) {
        Scaffold.of(scaffoldContext).showSnackBar(SnackBar(content: Text('${preloadData["title"]} retiré des films à voir')));
        isToSee = false;
      }
    }
    notifyListeners();
  }

  void onMovieSeenTapped(BuildContext scaffoldContext) async {
    Scaffold.of(scaffoldContext).hideCurrentSnackBar();
    if (!isSeen) {
      if (await firestore.setElementSeen(QueryTypes.movie, id, true)) {
        Scaffold.of(scaffoldContext).showSnackBar(SnackBar(content: Text('${preloadData["title"]} ajouté aux films vus')));
        isSeen = true;
      }
    }
    else {
      if (await firestore.setElementSeen(QueryTypes.movie, id, false)) {
        Scaffold.of(scaffoldContext).showSnackBar(SnackBar(content: Text('${preloadData["title"]} retiré des films vus')));
        isSeen = false;
      }
    }
    notifyListeners();
  }

  void onFavTapped(BuildContext scaffoldContext) async {
    Scaffold.of(scaffoldContext).hideCurrentSnackBar();
    if (!isFav) {
      if (await firestore.setElementFav(QueryTypes.movie, id, true)) {
        Scaffold.of(scaffoldContext).showSnackBar(SnackBar(content: Text('${preloadData["title"]} ajouté aux favoris')));
        isFav = true;
      }
    }
    else {
      if (await firestore.setElementFav(QueryTypes.movie, id, false)) {
        isFav = false;
        Scaffold.of(scaffoldContext).showSnackBar(SnackBar(content: Text('${preloadData["title"]} retiré des favoris')));
      }
    }
    notifyListeners();
  }

  onAddTagTapped() {
    AddTagView actualBottomSheetView;
    showModalBottomSheet(
      context: context, 
      builder: (context) => actualBottomSheetView = AddTagView(context, List.from(addedGenreTags), this.applyTagsEdits),
      isScrollControlled: true,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
    ).then((void value) => applyTagsEdits(actualBottomSheetView.globalController.chips));
  }

  void applyTagsEdits(List newTags) async {
    objectsStates[ElementsTypes.GenreTags] = States.Loading;
    notifyListeners();
    addedGenreTags = await firestore.updateElementTags(QueryTypes.movie, newTags, id) ?? addedGenreTags;
    objectsStates[ElementsTypes.GenreTags] = States.Added;
    notifyListeners();
  }
  bool dispElement(ElementsTypes element) {
    if (objectsStates[element] == States.Loading || objectsStates[element] == States.Added)
      return true;
    else return false;
  }
}