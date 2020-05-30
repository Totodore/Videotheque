import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/api/firestoreQueries.dart';
class LibraryBodyController extends ChangeNotifier {
  BuildContext context;
  QueryTypes type;
  final int CARROUSEL_LENGTH = 6;

  Map<ElementsTypes, States> objectsStates = Map.fromIterables(ElementsTypes.values, List.generate(ElementsTypes.values.length, (int index) => States.Nothing));
  Map<ElementsTypes, List> carrouselData = Map.fromIterables(ElementsTypes.values, List.generate(ElementsTypes.values.length, (int index) => []));

  LibraryBodyController(this.context, this.type) {
    getSampleToSee();
    getSampleFav();
    getSampleSeen();
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
}