import 'package:Videotheque/globals.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:Videotheque/views/person_view/person_view.dart';
import 'package:Videotheque/views/tv_view/tv_view.dart';

class CarrouselController extends ChangeNotifier {
  
  ElementsTypes type;
  List carrouselData;
  String route;
  BuildContext context;
  Function showBottomSheetEl;

  CarrouselController(this.context, this.type, this.carrouselData, [this.showBottomSheetEl]) {

    List toRemove = [];
    //faire en sorte que ca s'affiche pas plusieurs fois
    for(var i = 0; i<carrouselData.length; i++){
        var ele = carrouselData[i];
      for(var i2 = i+1;i2<carrouselData.length;i2++){
            var ele2 = carrouselData[i2];
            if(ele["id"] == ele2["id"])
              toRemove.add(ele2);
          }
    }
    for(var ele in toRemove)
        carrouselData.remove(ele);
    //On enlève tout ce qui n'as pas d'image et si ce sont des personnes qui sont affichées
    //On vérifie qu'elles ne réapparaissent pas plusieurs fois
    if (type == ElementsTypes.CastingCarrousel || type == ElementsTypes.CrewCarrousel || type == ElementsTypes.MadeByCarrousel) {
      route = "/element/person/";
    } else if (type == ElementsTypes.SimilarCarrousel || type == ElementsTypes.SeasonsCarrousel) {
      route = "/element/tv";
    }
  }

  void onElementTapped(int index, String heroTag) {
    GlobalsArgs.actualRoute = route;
    GlobalsArgs.isFromLibrary = false;
    GlobalsArgs.transfertArg = [carrouselData[index], heroTag];
    switch (type) {
      case ElementsTypes.SimilarCarrousel:
        Navigator.push(context, MaterialPageRoute(builder: (context) => TvView()));
        break;
      case ElementsTypes.CastingCarrousel:
        Navigator.push(context, MaterialPageRoute(builder: (context) => PersonView()));
        break;
      case ElementsTypes.CrewCarrousel:
        Navigator.push(context, MaterialPageRoute(builder: (context) => PersonView()));
        break;
      case ElementsTypes.GuestsCarrousel:
        Navigator.push(context, MaterialPageRoute(builder: (context) => PersonView()));
        break;
      case ElementsTypes.MadeByCarrousel:
        Navigator.push(context, MaterialPageRoute(builder: (context) => PersonView()));
        break;
      case ElementsTypes.SeasonsCarrousel:
        showBottomSheetEl(index, heroTag);
        break;
      case ElementsTypes.EpisodesCarrousel:
        showBottomSheetEl(index, heroTag);
        break;
      default:
        break;
    }
  }

  String getNameElement(int index) {
      return carrouselData[index]["name"];
  } 
  String getImageElement(int index) {
    if (type == ElementsTypes.CrewCarrousel || type == ElementsTypes.CastingCarrousel || type == ElementsTypes.MadeByCarrousel || type == ElementsTypes.GuestsCarrousel)
      return carrouselData[index]["profile_path"];
    else {
      return carrouselData[index]["poster_path"];
    }
  }
  
  ImageTypes get imageType {
    if (type == ElementsTypes.CrewCarrousel || type == ElementsTypes.CastingCarrousel || type == ElementsTypes.MadeByCarrousel || type == ElementsTypes.GuestsCarrousel)
      return ImageTypes.Profile;
    else return ImageTypes.Poster;
  }

  String get heroTag => Uuid().v1();
}