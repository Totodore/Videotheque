
import 'package:Videotheque/Globals.dart';
import 'package:Videotheque/models/api/ApiSearchModel.dart';
import 'package:Videotheque/models/api/ApiSearchMovieModel.dart';
import 'package:Videotheque/models/api/ApiSearchPersonModel.dart';
import 'package:Videotheque/models/api/ApiSearchTvModel.dart';
import 'package:Videotheque/views/SearchView/components/MovieCardComponent.dart';
import 'package:Videotheque/views/SearchView/components/PersonCardComponent.dart';
import 'package:Videotheque/views/SearchView/components/TvCardComponent.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ResultSearchController extends ChangeNotifier {
  QueryTypes sortType;
  ApiSearchModel data;
  BuildContext context;

  ResultSearchController(this.sortType, this.context, this.data);

  void knownElementTapped(String type, int index) {
    String route = "/element/$type/";
    GlobalsArgs.actualRoute = route;
    GlobalsArgs.transfertArg = List.from([data.results[index].toJson(), ""]);
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
      break;
    }
    return Container();
  }
}