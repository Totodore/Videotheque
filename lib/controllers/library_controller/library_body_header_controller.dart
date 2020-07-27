import 'package:Videotheque/globals.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';

class LibraryBodyHeaderController extends ChangeNotifier {
  final List<ElementsTypes> optionElems;
  final Map<ElementsTypes, List> carrouselData;

  LibraryBodyHeaderController(this.optionElems, this.carrouselData);

  
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
    return EnumToString.fromString(QueryTypes.values, carrouselData[element][0]["type"]);
  }

}