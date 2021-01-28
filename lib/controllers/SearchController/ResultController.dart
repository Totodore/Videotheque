
import 'package:Videotheque/Globals.dart';
import 'package:Videotheque/models/api/ApiSearchElModel.dart';
import 'package:Videotheque/models/api/ApiSearchModel.dart';
import 'package:Videotheque/models/api/ApiSearchMovieModel.dart';
import 'package:Videotheque/models/api/ApiSearchPersonModel.dart';
import 'package:Videotheque/models/api/ApiSearchTvModel.dart';
import 'package:Videotheque/models/api/ApiSearchCollectionModel.dart';
import 'package:Videotheque/views/SearchView/components/cards/MovieCardComponent.dart';
import 'package:Videotheque/views/SearchView/components/cards/PersonCardComponent.dart';
import 'package:Videotheque/views/SearchView/components/cards/TvCardComponent.dart';
import 'package:Videotheque/views/SearchView/components/cards/CollectionCardComponent.dart';
import 'package:Videotheque/views/SearchView/components/imgs/CollectionImgComponent.dart';
import 'package:Videotheque/views/SearchView/components/imgs/MovieImgComponent.dart';
import 'package:Videotheque/views/SearchView/components/imgs/PersonImgComponent.dart';
import 'package:Videotheque/views/SearchView/components/imgs/TvImgComponent.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ResultSearchController extends ChangeNotifier {
  QueryTypes sortType;
  ApiSearchModel data;
  BuildContext context;

  bool newSearchDisplay = true;

  ResultSearchController(this.sortType, this.context, this.data);

  void knownElementTapped(String type, ApiSearchElModel data) {
    String route = "/element/$type/";
    GlobalsArgs.actualRoute = route;
    print(data.toJson());
    GlobalsArgs.transfertArg = List.from([data.toJson(), ""]);
    GlobalsArgs.isFromLibrary = false;
    Navigator.pushNamed(context, route, arguments: data);
  }

  void elementTapped(String type, int index, String heroId) {
    String route = "/element/$type/";
    GlobalsArgs.actualRoute = route;
    GlobalsArgs.transfertArg = List.from([data.results[index].toJson(), heroId]);
    GlobalsArgs.isFromLibrary = false;
    Navigator.pushNamed(context, route, arguments: data);
  }

  Widget getCard(int index) {
    var el = data.results[index];
    var uuid = new Uuid().v4();
    switch (el.media_type) {
      case "movie":
        return MovieCardComponent(el.getAs<ApiSearchMovieModel>(), elementTapped, uuid, index);
      case "tv":
        return TvCardComponent(el.getAs<ApiSearchTvModel>(), elementTapped, uuid, index);
      case "person":
        var data = el.getAs<ApiSearchPersonModel>();
        return PersonCardComponent(data, elementTapped, uuid, knownElementTapped, index);
      case "collection":
        return CollectionCardComponent(el.getAs<ApiSearchCollectionModel>(), elementTapped, uuid, index);
      break;
    }
    return Container();
  }

  Widget getImg(int index) {
    var uuid = new Uuid().v4();
    var el = data.results[index];
    switch (el.media_type) {
      case "movie":
        return MovieImgComponent(el.getAs<ApiSearchMovieModel>(), uuid, elementTapped, index);
      case "tv":
        return TvImgComponent(el.getAs<ApiSearchTvModel>(), uuid, elementTapped, index);
      case "person":
        return PersonImgComponent(el.getAs<ApiSearchPersonModel>(), uuid, elementTapped, index);
      case "collection":
        return CollectionImgComponent(el.getAs<ApiSearchCollectionModel>(), uuid, elementTapped, index);
      break;
    }
    return Container();
  }
}