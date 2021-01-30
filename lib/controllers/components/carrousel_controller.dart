import 'package:Videotheque/Globals.dart';
import 'package:Videotheque/utils/SlidePageRoute.dart';
import 'package:Videotheque/views/collection_view/CollectionView.dart';
import 'package:Videotheque/views/movie_view/MovieView.dart';
import 'package:Videotheque/views/person_view/PersonView.dart';
import 'package:Videotheque/views/tv_view/TvView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CarrouselController extends ChangeNotifier {
  
  final QueryTypes _type;
  final List _carrouselData;
  final BuildContext _context;
  final Function _showEl;
  final bool _isEpisode;

  CarrouselController(this._context, this._type, this._carrouselData, [this._showEl, this._isEpisode]) {
    _sortAndFilterData();
  }

  //On enlève tout ce qui n'as pas d'image et si ce sont des personnes qui sont affichées
  //On vérifie qu'elles ne réapparaissent pas plusieurs fois
  void _sortAndFilterData() {
    List toRemove = [];
    //faire en sorte que ca s'affiche pas plusieurs fois
    for(var i = 0; i<_carrouselData.length; i++){
        var ele = _carrouselData[i];
      for(var i2 = i+1;i2<_carrouselData.length;i2++){
            var ele2 = _carrouselData[i2];
            if(ele["id"] == ele2["id"])
              toRemove.add(ele2);
          }
    }
    for(var ele in toRemove)
        _carrouselData.remove(ele);
  }

  void onElementTapped(int index, String heroTag) {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_showEl != null) {
        _showEl(index, heroTag);
        return;
      }

      GlobalsArgs.actualRoute = "/element/${GlobalsMessage.chipData[QueryTypes.values.indexOf(_type)]["route"]}";
      GlobalsArgs.transfertArg = [_carrouselData[index], heroTag];
      GlobalsArgs.isFromLibrary = false;
      switch (_type) {
        case QueryTypes.movie:
          Navigator.push(_context, SlideLeftRoute(page: MovieView()));
          break;
        case QueryTypes.tv:
          Navigator.push(_context, SlideLeftRoute(page: TvView()));
          break;
        case QueryTypes.person:
          Navigator.push(_context, SlideLeftRoute(page: PersonView()));
          break;
        case QueryTypes.collection:
          Navigator.push(_context, SlideLeftRoute(page: CollectionView()));
          break;
        default:
      }
    });
  }

  String getNameElement(int index) {
    if (_type == QueryTypes.movie)
      return _carrouselData[index]["title"] != null ? _carrouselData[index]["title"] : _carrouselData[index]["original_title"];
    else if (_type == QueryTypes.tv && _isEpisode)
      return "Épisode ${index+1}";
    else 
      return _carrouselData[index]["name"] != null ? _carrouselData[index]["name"] : _carrouselData[index]["original_name"];
  } 

  String getImageElement(int index) {
    if (_type == QueryTypes.person)
      return _carrouselData[index]["profile_path"];
    else
      return _carrouselData[index]["poster_path"];
  }

  ImageTypes getImageType(int index) {
    return GlobalsMessage.chipData[QueryTypes.values.indexOf(_type)]["image_type"];
  }

  String get heroTag => Uuid().v1();

  int get length => _carrouselData.length;

  bool get dispTitle => _type == QueryTypes.person || (_isEpisode ?? false);

  ImageTypes get imageType => _type == QueryTypes.person ? ImageTypes.Poster : ImageTypes.Profile;
}