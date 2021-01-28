import 'dart:async';
import 'dart:io';

import 'package:Videotheque/models/api/ApiSearchModel.dart';
import 'package:Videotheque/services/BarcodeLookup.dart';
import 'package:Videotheque/services/FireauthQueries.dart';
import 'package:Videotheque/services/FireconfigQueries.dart';
import 'package:Videotheque/services/FirestoreQueries.dart';
import 'package:Videotheque/Globals.dart';
import 'package:Videotheque/services/Preferences.dart';
import 'package:Videotheque/services/TmdbQueries.dart';
import 'package:Videotheque/utils/Singletons.dart';
import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ndialog/ndialog.dart';
import 'package:permission_handler/permission_handler.dart';

class SearchController extends ChangeNotifier {
  final focusNode = FocusNode();
  final searchInputController = TextEditingController();
  final tabLength = QueryTypes.values.length;
  final BuildContext context;
  String barcode;

  Map<QueryTypes, States> loadedViews = Map.fromIterables(QueryTypes.values, List.generate(QueryTypes.values.length, (int index) => States.Nothing)); //List which represent each view if it has been loaded
  //List which represent offset of result per view
  Map<QueryTypes, ApiSearchModel> dataLoadedView = Map.fromIterables(QueryTypes.values, List.generate(QueryTypes.values.length, (int index) => null)); 

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

  SearchController(this.context) {
    focusNode.requestFocus();
  }

  void searchQuery(String query) async {
    QueryTypes type = selectedSort; //On sauvegarde le type actuel au cas ou l'utilisateur change d'index pdt le chargement
    if (query == null || query.isEmpty) {
      clearView();
      notifyListeners();
      return;
    }
    actualQuery = query;
    loadedViews[type] = States.Loading;
    notifyListeners();

    ApiSearchModel result;
    switch (type) {
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
    }
    if (result.error != null) {
      loadedViews[type] = States.Error;
      print("Error while searching for $type: ${result.error}");
    }
    else if ((result.results?.length ?? 0) <= 0) {
      loadedViews[type] = States.Empty;
    } else {
      dataLoadedView[type] = result;
      loadedViews[type] = States.Added;
    }
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

  ApiSearchModel getDataResults(QueryTypes type) {
    return dataLoadedView[type];
  }

  bool isChipSelected(int index) => GlobalsMessage.chipData[index]["type"] == selectedSort; 

  void updateIsInnerBoxScrolled(bool isScrolled) {
    innerBoxScrolled = isScrolled;
    if (innerBoxScrolled)
      focusNode.unfocus();
  }

  Future<void> barcodeScan() async {
    if (!await _requestPermissions()) {
      GlobalsFunc.snackBar(context, "L'accès à la caméra est désactivé");
    } else
      _scan();
  }

  
  Future<bool> _requestPermissions() async {
    PermissionStatus status = await Permission.camera.request();
    return status == PermissionStatus.granted || status == PermissionStatus.restricted;
  }

  Future<void> _scan() async {
    CustomProgressDialog dialog;
    try {
      barcode = await BarcodeScanner.scan();
      dialog = this._dispLoadingDialog();
      searchInputController.text = await Singletons.instance<BarcodeLookup>().getTitle(barcode);
      searchInputController.selection = TextSelection.collapsed(offset: searchInputController.text.length);
      dialog?.dismiss();
      searchQuery(searchInputController.text);
      notifyListeners();
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        GlobalsFunc.snackBar(context, "L'accès à la caméra est désactivé");
      } else {
        GlobalsFunc.snackBar(context);
        print(e);
      }
      dialog?.dismiss();
    } on HttpException {
      GlobalsFunc.snackBar(context, "Erreur lors de la récupération du film, réessayez...");
      dialog?.dismiss();
    } on FormatException {
      // GlobalsFunc.snackBar(context, "Erreur lors du scan, réessayez...");
    } catch (e) {
      GlobalsFunc.snackBar(context, "Erreur lors du scan du code barre, réessayez...");
      dialog?.dismiss();
      print(e);
    }
  }

  CustomProgressDialog _dispLoadingDialog() {
    CustomProgressDialog progressDialog = CustomProgressDialog(context, 
      blur: 5,
      loadingWidget: LinearProgressIndicator(
        backgroundColor: GlobalsColor.green,
        valueColor: AlwaysStoppedAnimation<Color>(GlobalsColor.darkGreen),
      )
    );
    progressDialog.show();
    return progressDialog;
  }

  bool get newDisplayResults => Singletons.instance<Preferences>().newSearchUI;
}
