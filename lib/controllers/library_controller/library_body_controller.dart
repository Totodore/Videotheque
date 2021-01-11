import 'package:Videotheque/api/FireauthQueries.dart';
import 'package:Videotheque/api/FireconfigQueries.dart';
import 'package:Videotheque/api/FirestoreQueries.dart';
import 'package:Videotheque/api/TmdbQueries.dart';
import 'package:Videotheque/utils/Singletons.dart';
import 'package:Videotheque/utils/customChangeNotifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:Videotheque/globals.dart';
import 'package:flutter/material.dart';

class LibraryBodyController extends CustomChangeNotifier {
  final BuildContext context;
  final QueryTypes type;
  final int CARROUSEL_LENGTH = 6;
  final ScrollController sliverScrollController = ScrollController(keepScrollOffset: true);


  final List<ElementsTypes> _optionElems = [
    ElementsTypes.ToSeeCarrousel,
    ElementsTypes.SeenCarrousel,
    ElementsTypes.FavCarrousel
  ];

  Map<ElementsTypes, States> objectsStates = Map.fromIterables(
    ElementsTypes.values,
    List.generate(ElementsTypes.values.length, (int index) => States.Nothing
  )
  );

  Map<ElementsTypes, List> carrouselData = Map.fromIterables(
    ElementsTypes.values,
    List.generate(ElementsTypes.values.length, (int index) => [])
  );

  Map<String, dynamic> tags = {};
  List _libraryData = [];

  FireauthQueries fireauth = Singletons.instance<FireauthQueries>();
  FirestoreQueries firestore = Singletons.instance<FirestoreQueries>();
  FireconfigQueries fireconfig = Singletons.instance<FireconfigQueries>();
  TMDBQueries tmdbQueries = Singletons.instance<TMDBQueries>();


  LibraryBodyController(this.context, this.type) {

    for (ElementsTypes elem in _optionElems)
      objectsStates[elem] = States.Loading;
    getAllData();
    getTags();
  }

  getAllData() {
    objectsStates[ElementsTypes.MainData] = States.Loading;
    notifyListeners();
    if (type == QueryTypes.all)
      firestore.setElementsListener(type, onAllLibraryElement);
    else
      firestore.setElementsListener(type, onLibraryElement);
  }

  getTags() async {
    tags = await firestore.getTags();
    List inTags = [];
    if (type == QueryTypes.movie || type == QueryTypes.all) {
      inTags = (await tmdbQueries.getTagListMovie())["genres"];
      for (Map inTag in inTags) {
        tags[inTag["id"].toString()] = inTag["name"];
      }
    }
    if (type == QueryTypes.tv || type == QueryTypes.all){
      inTags = (await tmdbQueries.getTagListTv())["genres"];
      for (Map inTag in inTags) {
        tags[inTag["id"].toString()] = inTag["name"];
      }
    }
  }

  ///input type : [List<DocumentSnapshot>]
  void onAllLibraryElement(snapshots) {
    _libraryData = [];
    for (DocumentSnapshot snap in snapshots)
      _libraryData.addAll(snap.data().values);

    if (_libraryData != null && _libraryData.length > 0)
      objectsStates[ElementsTypes.MainData] = States.Added;
    else
      objectsStates[ElementsTypes.MainData] = States.Empty;
    _setHeaderData();
    if (this.mounted) notifyListeners();
  }

  ///arg type : [DocumentSnapshot]
  void onLibraryElement(snapshot) => onAllLibraryElement([snapshot]);

  
  _setHeaderData() {
    for (ElementsTypes elem in _optionElems) {
      carrouselData[elem] = _libraryData.where((data) {
        switch (elem) {
          case ElementsTypes.ToSeeCarrousel:
            return data["to_see"];
          case ElementsTypes.SeenCarrousel:
            return data["seen"];
          case ElementsTypes.FavCarrousel:
            return data["fav"];
          default:
            return false;
        }
      }).toList();
      if (carrouselData[elem] != null && carrouselData[elem].length > 0)
        objectsStates[elem] = States.Added;
      else
        objectsStates[elem] = States.Empty;
    }
    if (this.mounted) notifyListeners();
  }

  bool get displayLib {
    bool canDispLib = false;
    for (ElementsTypes option in _optionElems) {
      if (objectsStates[option] != States.Loading) canDispLib = true;
    }
    if (objectsStates[ElementsTypes.MainData] != States.Loading)
      canDispLib = true;
    return canDispLib;
  }

  List get libraryData => _libraryData;

  bool get isLibrarydataEmpty => _libraryData.length == 0;


  List<ElementsTypes> get optionElems => type == QueryTypes.all ? [ElementsTypes.FavCarrousel] : _optionElems;
}
