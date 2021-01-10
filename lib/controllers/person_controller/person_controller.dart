import 'package:Videotheque/api/FirestoreQueries.dart';
import 'package:Videotheque/components/alert_dialog_component.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/api/tmdbQueries.dart';
import 'package:Videotheque/views/person_view/addtag_view.dart';
import 'package:Videotheque/views/person_view/person_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PersonController extends ChangeNotifier {
  String heroTag;
  bool isAdded = false;
  bool isFav = false;
  String id;

  BuildContext context;

  Map preloadData;
  Map<ElementsTypes, States> objectsStates = Map.fromIterables(ElementsTypes.values, List.generate(ElementsTypes.values.length, (int index) => States.Nothing));
  Map<ElementsTypes, List> carrouselData = Map.fromIterables(ElementsTypes.values, List.generate(ElementsTypes.values.length, (int index) => []));
  List addedGenreTags = [];
  List loadedInfoTags = [];
  Map mainData = {};

  PersonController(this.context) {
    heroTag = GlobalsArgs.transfertArg[1];
    preloadData = GlobalsArgs.transfertArg[0];
    if (GlobalsArgs.isFromLibrary ?? false)
      convertDataToDBData();

    fetchDbId().then((id) {
      if (id != null) {
        fetchDbStats();
        fetchTags();
      }
      fetchDetails();
      fetchKnownForMovies();
      fetchKnownForTv();
    });
  }

  void convertDataToDBData() {
    preloadData["profile_path"] = preloadData["image_url"];
    preloadData["id"] = preloadData["base_id"];
    preloadData["backdrop_path"] = preloadData["backdrop_url"];
    preloadData["name"] = preloadData["title"];
  }

  Future fetchDbId() async {
    return id = await FirestoreQueries.getIdFromDbId(QueryTypes.person, preloadData["id"].toString());
  }

  void fetchDbStats() async {
    isAdded = true;
    isFav = await FirestoreQueries.isElementFav(QueryTypes.person, id);
    notifyListeners();
  }
  void clearDbStats() {
    isAdded = false;
    isFav = false;
  }
  void fetchDetails() async {
    objectsStates[ElementsTypes.MainData] = States.Loading;
    objectsStates[ElementsTypes.InfoTags] = States.Loading;
    objectsStates[ElementsTypes.GenreTags] = States.Loading;
    notifyListeners();
    mainData = await TMDBQueries.getPerson(preloadData["id"].toString());
    loadedInfoTags = [
      mainData["place_of_birth"] != null ? "Né(e) à ${mainData["place_of_birth"]}" : null,
      mainData["birthday"] != null  ? "Né(e) le ${DateFormat('dd/MM/yyyy').format(DateTime.parse(mainData["birthday"]))}" : null,
      mainData["deathday"] != null ? "Mort(e) le ${DateFormat('dd/MM/yyyy').format(DateTime.parse(mainData["deathday"]))}" : null
    ];
    loadedInfoTags.removeWhere((el) => el == null);
    
    objectsStates[ElementsTypes.MainData] = mainData["biography"] != null && mainData["biography"].length > 0 ? States.Added : States.Empty;
    objectsStates[ElementsTypes.InfoTags] = States.Added;
    objectsStates[ElementsTypes.GenreTags] = States.Empty;
    notifyListeners();
  }
  void fetchTags() async {
    addedGenreTags = await FirestoreQueries.getElementTags(QueryTypes.person, id);
  }

  void fetchKnownForMovies() async {
    objectsStates[ElementsTypes.KnownForMovieCarrousel] = States.Loading;
    notifyListeners();
    Map data = await TMDBQueries.getKnownForMovies(preloadData["id"].toString());
    List knownFor = List.from(data["cast"])..addAll(data["crew"]);
    knownFor.removeWhere((element) => element["poster_path"] == null);

    carrouselData[ElementsTypes.KnownForMovieCarrousel] = TMDBQueries.sortByPopularity(knownFor);
    objectsStates[ElementsTypes.KnownForMovieCarrousel] = knownFor != null && knownFor.length > 0 ? States.Added : States.Empty;
    notifyListeners();
  }

  void fetchKnownForTv() async {
    objectsStates[ElementsTypes.KnownForTvCarrousel] = States.Loading;
    notifyListeners();
    Map data = await TMDBQueries.getKnownForTv(preloadData["id"].toString());
    List knownFor = List.from(data["cast"])..addAll(data["crew"]);
    knownFor.removeWhere((element) => element["poster_path"] == null);

    carrouselData[ElementsTypes.KnownForTvCarrousel] = TMDBQueries.sortByPopularity(knownFor);
    objectsStates[ElementsTypes.KnownForTvCarrousel] = knownFor != null && knownFor.length > 0 ? States.Added : States.Empty;
    notifyListeners();
  }
  void addPerson() async {
    id = await FirestoreQueries.addElement(QueryTypes.person, preloadData);
    if (id != null) {
      isAdded = true;
    }
    notifyListeners();
  }

  void removePerson() {
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialogComponent(
        content: "Êtes-vous sur de supprimer cette personne de votre vidéothèque ?",
        onConfirmed: () async {  //On confirm
          if (await FirestoreQueries.removeElement(QueryTypes.person, id)) {
            clearDbStats();
            notifyListeners();
          }
          Navigator.pop(context);
        }, 
        onAbort: () { //On abort
          Navigator.pop(context);
        }, 
        mainColor: PersonView.baseColor
      );
    });
  }

  void onFavTapped(BuildContext scaffoldContext) async {
        Scaffold.of(scaffoldContext).hideCurrentSnackBar();
    if (!isFav) {
      if (await FirestoreQueries.setElementFav(QueryTypes.person, id, true)) {
        Scaffold.of(scaffoldContext).showSnackBar(SnackBar(content: Text('${preloadData["name"]} ajouté aux favoris')));
        isFav = true;
      }
    }
    else {
      if (await FirestoreQueries.setElementFav(QueryTypes.person, id, false)) {
        isFav = false;
        Scaffold.of(scaffoldContext).showSnackBar(SnackBar(content: Text('${preloadData["name"]} retiré des favoris')));
      }
    }
    notifyListeners();
  }

  void onAddTagTapped() {
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
    addedGenreTags = await FirestoreQueries.updateElementTags(QueryTypes.person, newTags, id) ?? addedGenreTags;
      
    objectsStates[ElementsTypes.GenreTags] = addedGenreTags.length > 0 ? States.Added : States.Empty;
    notifyListeners();
  }

  bool dispElement(ElementsTypes element) {
    if (objectsStates[element] == States.Loading || objectsStates[element] == States.Added)
      return true;
    else return false;
  }
}