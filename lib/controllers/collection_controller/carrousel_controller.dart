import 'package:Videotheque/globals.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:Videotheque/views/movie_view/movie_view.dart';

class CarrouselController extends ChangeNotifier {
  
  List carrouselData;
  String route;
  BuildContext context;

  CarrouselController(BuildContext viewContext, List viewData) {
    carrouselData = viewData;
    context = viewContext;

    List toRemove = [];
    carrouselData.removeWhere((el) => (el["profile_path"] == null && el["poster_path"] == null));
    carrouselData.sort((a, b) => a["popularity"] < b["popularity"] ? 1 : -1);
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
  }

  void onElementTapped(int index, String heroTag) {
    GlobalsArgs.actualRoute = route;
    GlobalsArgs.transfertArg = [carrouselData[index], heroTag];
    Navigator.push(context, MaterialPageRoute(builder: (context) => MovieView()));
  }

  String getNameElement(int index) {
    return carrouselData[index]["title"] != null ? carrouselData[index]["title"] : carrouselData[index]["original_title"];
  } 

  String getImageElement(int index) {
    return carrouselData[index]["poster_path"];
  }

  String get heroTag => Uuid().v1();

  ImageTypes get imageType => ImageTypes.Poster;
}