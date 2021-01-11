import 'package:Videotheque/models/FireconfigInfos.dart';
import 'package:Videotheque/services/FireauthQueries.dart';
import 'package:Videotheque/services/FireconfigQueries.dart';
import 'package:Videotheque/services/FirestoreQueries.dart';
import 'package:Videotheque/Globals.dart';
import 'package:Videotheque/utils/Singletons.dart';
import 'package:Videotheque/utils/CustomChangeNotifier.dart';
import 'package:Videotheque/views/home_view/carrousel_view.dart';
import 'package:Videotheque/views/home_view/components/InfoComponent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends CustomChangeNotifier {
  final BuildContext _context;
  List<HomeCarrousels> _toDisplayCarroussels = List.from(HomeCarrousels.values)..shuffle();
  List _libraryData = [];
  bool _isMailConfirmed = true;

  States _dataState = States.Loading;


  FireauthQueries fireauth = Singletons.instance<FireauthQueries>();
  FirestoreQueries firestore = Singletons.instance<FirestoreQueries>();
  FireconfigQueries fireconfig = Singletons.instance<FireconfigQueries>();
  
  HomeController(this._context) {
    if (this.mounted)
      _getLibrary();
  }


  void _getLibrary() {
    _dataState = States.Loading;
    firestore.setElementsListener(QueryTypes.all, _onAllLibraryElement);
  }

  ///type : [List<DocumentSnapshot>]
  void _onAllLibraryElement(var snapshots) async {
     _libraryData = [];
    for (DocumentSnapshot snap in snapshots)
      _libraryData.addAll(snap.data().values);

    try {
      _isMailConfirmed = await fireauth.userMailVerified;
      print("Mail confirmed : $_isMailConfirmed");
    } on Exception {
      _isMailConfirmed = true;
    }
    if (_libraryData != null && _libraryData.length > 0)
      _dataState = States.Added;
    else
      _dataState = States.Empty;
    if (this.mounted)
      notifyListeners();
  }

  List _getRecentElements() {
    return _libraryData..sort((a, b) => (a["creation_date"] ?? 0) > (b["creation_date"] ?? 0) ? -1 : 1);
  }
  List _getLastSeen() {
    return _libraryData.where((element) => element["seen"]).toList()
      ..sort((a, b) => (a["seen_timestamp"] ?? 0) < (b["seen_timestamp"] ?? 0) ? 1 : -1);
  }
  List _getToSee() {
    return _libraryData.where((element) => element["to_see"]).toList()
      ..sort((a, b) => (a["to_see_timestamp"] ??= 0) < (b["to_see_timestamp"] ?? 0) ? 1 : -1);
  }

  void sendMailConfirm() {
    fireauth.sendMailConfirm(_context);
  }

  void mailSended() async {
    await fireauth.reloadData();
    _isMailConfirmed ??= await fireauth.userMailVerified;
    notifyListeners();
  }

  void onDismissed(FireconfigInfos infos, [bool link = false]) async {
    final shared = await SharedPreferences.getInstance();
    if ((link && (infos.dismiss_click ?? false))) {
      launch(infos.link);
      await shared.setBool(infos.id, true);
      await fireconfig.fetch();
      notifyListeners();
    } else if (link && !(infos.dismiss_click ?? false))
      launch(infos.link);
    else if (!link) {
      await shared.setBool(infos.id, true);
      await fireconfig.fetch();
      notifyListeners();
    }
  }

  HomeCarrousels getRandomCarrousel(int index) {
    HomeCarrousels carrousel = _toDisplayCarroussels[index];
    return _isCarrouselEmpty(carrousel) ? null : carrousel;
  }

  bool _isCarrouselEmpty(HomeCarrousels carrousel) => getCarrouselData(carrousel).isEmpty;
  
  List getCarrouselData(HomeCarrousels type) {
    switch (type) {
      case HomeCarrousels.LastAdded:
        return _getRecentElements();
      case HomeCarrousels.Seen:
        return _getLastSeen();
      case HomeCarrousels.ToSee:
        return _getToSee();
      default: return null;
    }
  } 
  String getCarrouselTitle(HomeCarrousels type) => GlobalsMessage.carrouselsTitles[type];


  bool get isLoading => _dataState == States.Loading;
  bool get hasNoContent => _dataState == States.Empty;

  bool get mailConfirmed => _isMailConfirmed;
  int get carrouselLength => HomeCarrousels.values.length;

  List<Widget> get carrousels {
    return List.generate(carrouselLength, (int index) {
      HomeCarrousels type = getRandomCarrousel(index);
      if (type == null) return Container();
      return CarrouselView(type, getCarrouselData(type), getCarrouselTitle(type));
    });
  }

  List<Widget> get infos {
    return List.generate(fireconfig.infosLength, (i) => InfoComponent(fireconfig.infos[i], this.onDismissed));
  }
}