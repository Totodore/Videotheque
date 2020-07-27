import 'package:Videotheque/utils/customChangeNotifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/api/firestoreQueries.dart';
import 'package:flutter/material.dart';

class LibraryBodyController extends CustomChangeNotifier {
  final BuildContext context;
  final QueryTypes type;
  final int CARROUSEL_LENGTH = 6;

  final List<ElementsTypes> optionElems = [
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

  List _libraryData = [];

  final ScrollController _sliverScrollController = ScrollController(keepScrollOffset: true);

  LibraryBodyController(this.context, this.type) {

    for (ElementsTypes elem in optionElems)
      objectsStates[elem] = States.Loading;

    getAllData();
  }

  getAllData() {
    objectsStates[ElementsTypes.MainData] = States.Loading;
    notifyListeners();
    if (type == QueryTypes.all)
      FirestoreQueries.setElementsListener(type, onAllLibraryElement);
    else
      FirestoreQueries.setElementsListener(type, onLibraryElement);
  }

  ///input type : [List<DocumentSnapshot>]
  void onAllLibraryElement(snapshots) {
    _libraryData = [];
    for (DocumentSnapshot snap in snapshots)
      _libraryData.addAll(snap.data.values);

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
    for (ElementsTypes elem in optionElems) {
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
    for (ElementsTypes option in optionElems) {
      if (objectsStates[option] != States.Loading) canDispLib = true;
    }
    if (objectsStates[ElementsTypes.MainData] != States.Loading)
      canDispLib = true;
    return canDispLib;
  }

  ScrollController get sliverScrollController => _sliverScrollController;

  List get libraryData => _libraryData;


}
