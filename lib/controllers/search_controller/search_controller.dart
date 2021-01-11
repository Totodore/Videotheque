import 'dart:async';

import 'package:Videotheque/api/FireauthQueries.dart';
import 'package:Videotheque/api/FireconfigQueries.dart';
import 'package:Videotheque/api/FirestoreQueries.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/api/TmdbQueries.dart';
import 'package:Videotheque/utils/Singletons.dart';
import 'package:flutter/material.dart';

class SearchController extends ChangeNotifier {
  final focusNode = FocusNode();
  final searchInputController = TextEditingController();
  final tabLength = QueryTypes.values.length;

  Map<QueryTypes, States> loadedViews = Map.fromIterables(QueryTypes.values, List.generate(QueryTypes.values.length, (int index) => States.Nothing)); //List which represent each view if it has been loaded
  //List which represent offset of result per view
  Map<QueryTypes, List> dataLoadedView = Map.fromIterables(QueryTypes.values, List.generate(QueryTypes.values.length, (int index) => null)); 

  QueryTypes selectedSort = QueryTypes.all;
  int tabIndex = 0;
  TabController resultsPageController;
  Timer delayOkSearch;
  bool innerBoxScrolled;
  bool test = true;
  String actualQuery = "";
  bool triggerChangeListener = false;

  FireauthQueries fireauth = Singletons.instance<FireauthQueries>();
  FirestoreQueries firestore = Singletons.instance<FirestoreQueries>();
  FireconfigQueries fireconfig = Singletons.instance<FireconfigQueries>();
  TMDBQueries tmdbQueries = Singletons.instance<TMDBQueries>();

  SearchController() {
    focusNode.requestFocus();
  }
  
  void searchQuery(String query) async {
    QueryTypes searchingSelectedSort = selectedSort; //On sauvegarde le type actuel au cas ou l'utilisateur change d'index pdt le chargement
    if (query == null || query.isEmpty) {
      clearView();
      notifyListeners();
      return;
    }
    actualQuery = query;
    loadedViews[searchingSelectedSort] = States.Loading;
    notifyListeners();

    Map<String, dynamic> result;
    switch (searchingSelectedSort) {
      case QueryTypes.all:
        result = await tmdbQueries.onlineSearchMulti(query);
        break;
      case QueryTypes.movie:
        result = await tmdbQueries.onlineSearchMovie(query);
        break;
      case QueryTypes.person:
        result = await tmdbQueries.onlineSearchPerson(query);
        break;
      case QueryTypes.tv:
        result = await tmdbQueries.onlineSearchTV(query);
        break;
      case QueryTypes.collection:
        result = await tmdbQueries.onlineSearchCollection(query);
        break;
      // case QueryTypes.companies:
        // result = await tmdbQueries.onlineSearchCompanies(query);
        // break;
    }

    if (result["error"] != null) {
      loadedViews[searchingSelectedSort] = States.Error;
      notifyListeners();
      return;
    }
    else if (result["results"] == null || List.from(result["results"]).length == 0) {
      loadedViews[searchingSelectedSort] = States.Empty;
      notifyListeners();
      return;
    }   
    dataLoadedView[searchingSelectedSort] = result["results"];
    loadedViews[searchingSelectedSort] = States.Added;
    notifyListeners();
  }

  void onchangeQuery(String query) {
    if (query == null || query.length == 0)
      clearView();
    if (delayOkSearch != null) {
      delayOkSearch.cancel();
    }
    delayOkSearch = Timer(Duration(milliseconds: 500), () {delayOkSearch = null; searchQuery(query);});
  }

  void clearView() {
    searchInputController.clear();
    actualQuery = "";
    dataLoadedView = Map.fromIterables(QueryTypes.values, List.generate(QueryTypes.values.length, (int index) => null));
    loadedViews = Map.fromIterables(QueryTypes.values, List.generate(QueryTypes.values.length, (int index) => States.Nothing));
    notifyListeners();
  }

  void updateTabIndex(int index) {
    selectedSort = QueryTypes.values[index];
    tabIndex = index;
    notifyListeners();
    if (loadedViews[QueryTypes.values[index]] == States.Nothing && actualQuery.length > 0) {
      searchQuery(actualQuery);
    }
  }

  List getDataResults(QueryTypes type) {
    return dataLoadedView[type];
  }

  bool isChipSelected(int index) => GlobalsMessage.chipData[index]["type"] == selectedSort; 

  void updateIsInnerBoxScrolled(bool isScrolled) {
    innerBoxScrolled = isScrolled;
    if (innerBoxScrolled)
      focusNode.unfocus();
  }
}
