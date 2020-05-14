
import 'package:Videotheque/controllers/search_controller/search_controller.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/api/tmdbQueries.dart';
import 'package:flutter/material.dart';

class ResultSearchController extends ChangeNotifier {
  QueryTypes sortType;
  List data;
  BuildContext context;

  ResultSearchController(QueryTypes selectedSortType, BuildContext buildContext, List inputData) {
    sortType = selectedSortType;
    data = inputData;
    context = buildContext;
  }


  void knownElementTapped(String type, Map data) {
    String route = "/element/$type/";
    GlobalsArgs.actualRoute = route;
    GlobalsArgs.transfertArg = List.from([data, ""]);
    Navigator.pushNamed(context, route, arguments: data);
  }

  void elementTapped(String type, Map data, String heroId) {
    String route = "/element/$type/";
    GlobalsArgs.actualRoute = route;
    GlobalsArgs.transfertArg = List.from([data, heroId]);
    Navigator.pushNamed(context, route, arguments: data);
  }
}