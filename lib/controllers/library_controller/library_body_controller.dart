import 'package:Videotheque/utils/customChangeNotifier.dart';
import 'package:Videotheque/views/collection_view/collection_view.dart';
import 'package:Videotheque/views/library_view/sortby_view.dart';
import 'package:Videotheque/views/movie_view/movie_view.dart';
import 'package:Videotheque/views/person_view/person_view.dart';
import 'package:Videotheque/views/tv_view/tv_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/api/firestoreQueries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:uuid/uuid.dart';

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
      List.generate(
          ElementsTypes.values.length, (int index) => States.Nothing));
  Map<ElementsTypes, List> carrouselData = Map.fromIterables(
      ElementsTypes.values,
      List.generate(ElementsTypes.values.length, (int index) => []));

  List _libraryData = [];

  SortOptions _sortOption = SortOptions.Popularity;

  final StickyHeaderController _libraryHeaderController =
      StickyHeaderController();
  final ScrollController _sliverScrollController =
      ScrollController(keepScrollOffset: true);

  LibraryBodyController(
      this.context, this.type, this.rippleAnimationController) {
    for (ElementsTypes elem in optionElems)
      objectsStates[elem] = States.Loading;

    rippleAnimation =
        Tween(begin: 0.0, end: 1.0).animate(rippleAnimationController);
    rippleAnimationController.addStatusListener(onRippleAnimation);

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

  setOptionsData() async {
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

  ///input type : [List<DocumentSnapshot>]
  void onAllLibraryElement(snapshots) {
    _libraryData = [];
    for (DocumentSnapshot snap in snapshots)
      _libraryData.addAll(snap.data.values);

    sortElements(_sortOption);
    if (_libraryData != null && _libraryData.length > 0)
      objectsStates[ElementsTypes.MainData] = States.Added;
    else
      objectsStates[ElementsTypes.MainData] = States.Empty;
    if (this.mounted) notifyListeners();

    setOptionsData();
  }

  ///arg type : [DocumentSnapshot]
  void onLibraryElement(snapshot) => onAllLibraryElement([snapshot]);

  void sortElements(SortOptions sortOptions) {
    _libraryData.sort((a, b) {
      switch (sortOptions) {
        case SortOptions.Popularity:
          return b["popularity"].compareTo(a["popularity"]);
        case SortOptions.Alpha1:
          return a["title"].compareTo(b["title"]);
        case SortOptions.Alpha2:
          return b["title"].compareTo(a["title"]);
        case SortOptions.Date:
          return a["creation_date"].compareTo(b["creation_date"]);
        case SortOptions.Fav:
          return a["fav"] ? 1 : b["fav"] ? -1 : 0;
        case SortOptions.Seen:
          return a["seen"] ? 1 : b["seen"] ? -1 : 0;
        case SortOptions.ToSee:
          return a["to_see"] ? 1 : b["to_see"] ? -1 : 0;
        default:
          return 0;
      }
    });
    notifyListeners();
  }

  void onSortButtonClick() {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => SortByView(this, _sortOption),
      animationType: DialogTransitionType.slideFromBottom,
      duration: const Duration(milliseconds: 400),
    );
  }
  onElementTapped(int index, String heroTag) async {
    QueryTypes type =
        EnumToString.fromString(QueryTypes.values, _libraryData[index]["type"]);
    GlobalsArgs.actualRoute = "/element/" +
        GlobalsMessage.chipData[QueryTypes.values.indexOf(type)]["route"];
    GlobalsArgs.transfertArg = [_libraryData[index], heroTag];
    GlobalsArgs.isFromLibrary = true;
    switch (GlobalsArgs.actualRoute) {
      case "/element/movie":
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => MovieView()));
        break;
      case "/element/person":
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => PersonView()));
        break;
      case "/element/tv":
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => TvView()));
        break;
      case "/element/collection":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => CollectionView()));
        break;
      default:
    }
  }

  bool isSingleElement(ElementsTypes element) {
    if (carrouselData[element].length > 1)
      return false;
    else
      return true;
  }

  Map getFirstElement(ElementsTypes element) {
    return carrouselData[element][0];
  }

  QueryTypes getFirstElementType(ElementsTypes element) {
    return EnumToString.fromString(
        QueryTypes.values, carrouselData[element][0]["type"]);
  }

  bool dispElement(ElementsTypes element) {
    if (objectsStates[element] == States.Loading ||
        objectsStates[element] == States.Added)
      return true;
    else
      return false;
  }

  bool get displayLib {
    bool canDispLib = true;
    for (ElementsTypes option in optionElems) {
      if (objectsStates[option] != States.Added) canDispLib = false;
    }
    if (objectsStates[ElementsTypes.MainData] != States.Added)
      canDispLib = false;
    return canDispLib;
  }

  int get libraryLength => _libraryData.length;

  String get heroTag => Uuid().v1();

  String getNameElement(int index) {
    return _libraryData[index]["title"];
  }

  String getImageElement(int index) {
    return _libraryData[index]["image_url"];
  }

  QueryTypes getElementType(int index) {
    return EnumToString.fromString(
        QueryTypes.values, _libraryData[index]["type"]);
  }

  ImageTypes getImageType(int index) {
    QueryTypes type =
        EnumToString.fromString(QueryTypes.values, _libraryData[index]["type"]);
    return GlobalsMessage.chipData[QueryTypes.values.indexOf(type)]
        ["image_type"];
  }

  StickyHeaderController get libraryHeaderController =>
      _libraryHeaderController;

  ScrollController get sliverScrollController => _sliverScrollController;

  closeDialogSort(SortOptions newOption) {
    Navigator.of(context).pop();
    if (newOption != _sortOption) {
      _sortOption = newOption;
      sortElements(_sortOption);
    }
  }

  bool get dispSearchBar => _displaySearchBar;
}
