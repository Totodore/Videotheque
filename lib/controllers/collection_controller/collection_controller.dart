import 'package:Videotheque/api/firestoreQueries.dart';
import 'package:Videotheque/components/alert_dialog_component.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/api/tmdbQueries.dart';
import 'package:Videotheque/views/collection_view/addtag_view.dart';
import 'package:Videotheque/views/collection_view/collection_view.dart';
import 'package:flutter/material.dart';

class CollectionController extends ChangeNotifier {
  BuildContext context;
  BuildContext scaffoldContext;
  String id;
  String heroTag;
  Map data;
  String overview;
  bool isAdded = false;
  bool isFav = false;
  bool isToSee = false;
  bool isSeen = false;
  List addedGenreTags = [];

  Map<ElementsTypes, States> objectsStates = Map.fromIterables(ElementsTypes.values, List.generate(ElementsTypes.values.length, (int index) => States.Nothing));
  Map<ElementsTypes, List> carrouselData = Map.fromIterables(ElementsTypes.values, List.generate(ElementsTypes.values.length, (int index) => []));

  CollectionController(this.context) {
    heroTag = GlobalsArgs.transfertArg[1];
    data = GlobalsArgs.transfertArg[0];
    if (GlobalsArgs.isFromLibrary)
      convertDataToDBData();

    fetchDbId().then((id) {
      if (id != null) {//Si le film est ajouté
        fetchDbStats();
        fetchTags();
      }
    });
    fetchDetails();
  }

  void convertDataToDBData() {
    data["poster_path"] = data["image_url"];
    data["id"] = data["base_id"];
    data["backdrop_path"] = data["backdrop_url"];
    data["name"] = data["title"];
  }


  Future fetchDbId() async {
    return id = await FirestoreQueries.getIdFromDbId(QueryTypes.collection, data["id"].toString());
  }

  void fetchDbStats() async {
    isAdded = true;
    isToSee = await FirestoreQueries.isElementToSee(QueryTypes.collection, id);
    isSeen = await FirestoreQueries.isElementSeen(QueryTypes.collection, id);
    isFav = await FirestoreQueries.isElementFav(QueryTypes.collection, id);
    notifyListeners();
  }
  void clearDbStats() {
    isAdded = false;
    isToSee = false;
    isSeen = false;
    isFav = false;
  }
  
  void addCollection() async {
    id = await FirestoreQueries.addElement(QueryTypes.collection, data);
    if (id != null) {
      isAdded = true;
    }
    notifyListeners();
  }

  void removeCollection() {
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialogComponent(
        content: "Êtes-vous sur de supprimer cette collection de votre vidéothèque ?",
        onConfirmed: () async {  //On confirm
          if (await FirestoreQueries.removeElement(QueryTypes.collection, id)) {
            clearDbStats();
            notifyListeners();
          }
          Navigator.pop(context);
        },
        onAbort: () { //On abort
          Navigator.pop(context);
        },
        mainColor: CollectionView.baseColor
      );
    });
  }

  void onCollectionToSeeTapped(BuildContext scaffoldContext) async {
    Scaffold.of(scaffoldContext).hideCurrentSnackBar();
    if (!isToSee) {
      if (await FirestoreQueries.setElementToSee(QueryTypes.collection, id, true)) {
        Scaffold.of(scaffoldContext).showSnackBar(SnackBar(content: Text('${data["name"]} ajouté aux collections à voir')));
        isToSee = true;
      }
    }
    else {
      if (await FirestoreQueries.setElementToSee(QueryTypes.collection, id, false)) {
        Scaffold.of(scaffoldContext).showSnackBar(SnackBar(content: Text('${data["name"]} retiré des collections à voir')));
        isToSee = false;
      }
    }
    notifyListeners();
  }

  void onCollectionSeenTapped(BuildContext scaffoldContext) async {
    Scaffold.of(scaffoldContext).hideCurrentSnackBar();
    if (!isSeen) {
      if (await FirestoreQueries.setElementSeen(QueryTypes.collection, id, true)) {
        Scaffold.of(scaffoldContext).showSnackBar(SnackBar(content: Text('${data["name"]} ajouté aux collections vues')));
        isSeen = true;
      }
    }
    else {
      if (await FirestoreQueries.setElementSeen(QueryTypes.collection, id, false)) {
        Scaffold.of(scaffoldContext).showSnackBar(SnackBar(content: Text('${data["name"]} retiré des collections vues')));
        isSeen = false;
      }
    }
    notifyListeners();
  }

  void onFavTapped(BuildContext scaffoldContext) async {
    Scaffold.of(scaffoldContext).hideCurrentSnackBar();
    if (!isFav) {
      if (await FirestoreQueries.setElementFav(QueryTypes.collection, id, true)) {
        Scaffold.of(scaffoldContext).showSnackBar(SnackBar(content: Text('${data["title"]} ajouté aux favoris')));
        isFav = true;
      }
    }
    else {
      if (await FirestoreQueries.setElementFav(QueryTypes.collection, id, false)) {
        isFav = false;
        Scaffold.of(scaffoldContext).showSnackBar(SnackBar(content: Text('${data["title"]} retiré des favoris')));
      }
    }
    notifyListeners();
  }

  void fetchTags() async {
    objectsStates[ElementsTypes.GenreTags] = States.Loading;
    notifyListeners();
    addedGenreTags = await FirestoreQueries.getElementTags(QueryTypes.collection, id);
    objectsStates[ElementsTypes.GenreTags] = States.Added;
    notifyListeners();
  }
  void fetchDetails() async {
    objectsStates[ElementsTypes.MoviesCarrousel] = States.Loading;
    objectsStates[ElementsTypes.MainData] = States.Loading;
    notifyListeners();
    Map results = await TMDBQueries.getCollection(data["id"].toString());
    List movies = results["parts"];
    if (movies != null)
      movies.removeWhere((el) => el["poster_path"] == null);

    overview = results["overview"];
    carrouselData[ElementsTypes.MoviesCarrousel] = movies;
    
    if (overview != null && overview.length > 2)
      objectsStates[ElementsTypes.MainData] = States.Added;
    else 
      objectsStates[ElementsTypes.MainData] = States.Empty;
    if (movies != null && movies.length > 0)
      objectsStates[ElementsTypes.MoviesCarrousel] = States.Added;
    else
      objectsStates[ElementsTypes.MoviesCarrousel] = States.Empty;
    notifyListeners();
  }

  bool dispElement(ElementsTypes element) {
    if (objectsStates[element] == States.Loading || objectsStates[element] == States.Added)
      return true;
    else return false;
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
    addedGenreTags = await FirestoreQueries.updateElementTags(QueryTypes.collection, newTags, id) ?? addedGenreTags;
    objectsStates[ElementsTypes.GenreTags] = addedGenreTags.length > 0 ? States.Added : States.Empty;
    notifyListeners();
  }
}