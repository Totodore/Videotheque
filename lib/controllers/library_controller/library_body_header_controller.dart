import 'package:Videotheque/controllers/library_controller/library_body_controller.dart';
import 'package:Videotheque/globals.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';

class LibraryBodyHeaderController extends ChangeNotifier {
  final List<ElementsTypes> optionElems;
  Map<ElementsTypes, List> carrouselData;
  final LibraryBodyController parentController;

  LibraryBodyHeaderController(this.optionElems, this.parentController) {
    carrouselData = parentController.carrouselData;
  }

  bool isEmpty(ElementsTypes element) => carrouselData[element].length == 0 ?? true;

  
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