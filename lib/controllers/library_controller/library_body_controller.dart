import 'package:Videotheque/views/collection_view/collection_view.dart';
import 'package:Videotheque/views/movie_view/movie_view.dart';
import 'package:Videotheque/views/person_view/person_view.dart';
import 'package:Videotheque/views/tv_view/tv_view.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/api/firestoreQueries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:uuid/uuid.dart';
class LibraryBodyController extends ChangeNotifier {
  BuildContext context;
  QueryTypes type;
  final int CARROUSEL_LENGTH = 6;

  Map<ElementsTypes, States> objectsStates = Map.fromIterables(ElementsTypes.values, List.generate(ElementsTypes.values.length, (int index) => States.Nothing));
  Map<ElementsTypes, List> carrouselData = Map.fromIterables(ElementsTypes.values, List.generate(ElementsTypes.values.length, (int index) => []));

  List libraryData = [];

  StickyHeaderController libraryHeaderController = StickyHeaderController(); 

  LibraryBodyController(this.context, this.type) {
    getSampleToSee();
    getSampleFav();
    getSampleSeen();
    getAllData();
  } 

  getAllData() async {
    objectsStates[ElementsTypes.MainData] = States.Loading;
    notifyListeners();
    Map data = await FirestoreQueries.getAllElements(type);
    if (data != null) libraryData = data.values.toList();
    data != null && data.length > 0 ? objectsStates[ElementsTypes.MainData] = States.Added : objectsStates[ElementsTypes.MainData] = States.Empty;
    notifyListeners();
  }

  getSampleToSee() async {
    objectsStates[ElementsTypes.ToSeeCarrousel] = States.Loading;
    notifyListeners();
    Map data = await FirestoreQueries.getElementsFromOptions(type, Options.ToSee, CARROUSEL_LENGTH);
    if (data != null) carrouselData[ElementsTypes.ToSeeCarrousel] = data.values.toList();
    data != null && data.length > 0 ? objectsStates[ElementsTypes.ToSeeCarrousel] = States.Added : objectsStates[ElementsTypes.ToSeeCarrousel] = States.Empty;
    notifyListeners();
  }

  getSampleSeen() async {
    objectsStates[ElementsTypes.SeenCarrousel] = States.Loading;
    notifyListeners();
    Map data = await FirestoreQueries.getElementsFromOptions(type, Options.Seen, CARROUSEL_LENGTH);
    if (data != null) carrouselData[ElementsTypes.SeenCarrousel] = data.values.toList();
    data != null && data.length > 0 ? objectsStates[ElementsTypes.SeenCarrousel] = States.Added : objectsStates[ElementsTypes.SeenCarrousel] = States.Empty;
    notifyListeners();
  }

  getSampleFav() async {
    objectsStates[ElementsTypes.FavCarrousel] = States.Loading;
    notifyListeners();
    Map data = await FirestoreQueries.getElementsFromOptions(type, Options.Fav, CARROUSEL_LENGTH);
    if (data != null) carrouselData[ElementsTypes.FavCarrousel] = data.values.toList();
    data != null && data.length > 0 ? objectsStates[ElementsTypes.FavCarrousel] = States.Added : objectsStates[ElementsTypes.FavCarrousel] = States.Empty;
    notifyListeners();
  }

  onElementTapped(int index, String heroTag) async {
    QueryTypes type = EnumToString.fromString(QueryTypes.values, libraryData[index]["type"]);
    GlobalsArgs.actualRoute = "/element/"+GlobalsMessage.chipData[QueryTypes.values.indexOf(type)]["route"];
    GlobalsArgs.transfertArg = [libraryData[index], heroTag];
    GlobalsArgs.isFromLibrary = true;
    switch (GlobalsArgs.actualRoute) {
      case "/element/movie":
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MovieView()));
        break;
      case "/element/person":
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PersonView()));
        break;
      case "/element/tv":
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TvView()));
        break;
      case "/element/collection":
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CollectionView()));
        break;
      default:
    }
  }

  bool isSingleElement(ElementsTypes element) {
    if (carrouselData[element].length > 1) return false;
    else return true;
  }

  Map getFirstElement(ElementsTypes element) {
    return carrouselData[element][0];
  }
  QueryTypes getFirstElementType(ElementsTypes element) {
    return EnumToString.fromString(QueryTypes.values, carrouselData[element][0]["type"]);
  }

  bool dispElement(ElementsTypes element) {
    if (objectsStates[element] == States.Loading || objectsStates[element] == States.Added)
      return true;
    else return false;
  }

  int get libraryLength => libraryData.length;

  String get heroTag => Uuid().v1();

  
  String getNameElement(int index) {
      return libraryData[index]["title"];
  } 
  String getImageElement(int index) {
      return libraryData[index]["image_url"];
  }
  
  ImageTypes getImageType(int index) {
    QueryTypes type = EnumToString.fromString(QueryTypes.values, libraryData[index]["type"]);
    return GlobalsMessage.chipData[QueryTypes.values.indexOf(type)]["image_type"];
  }

}