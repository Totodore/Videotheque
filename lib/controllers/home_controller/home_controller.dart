import 'package:Videotheque/api/fireconfigQueries.dart';
import 'package:Videotheque/api/firestoreQueries.dart';
import 'package:Videotheque/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends ChangeNotifier {
  final BuildContext _context;
  List<HomeCarrousels> _toDisplayCarroussels = List.from(HomeCarrousels.values)..shuffle();
  List _libraryData = [];
  bool _askTransferDbDismissed = false;

  States _dataState = States.Loading;

  HomeController(this._context) {
    _getLibrary();
  }


  void _getLibrary() {
    _dataState = States.Loading;
    FirestoreQueries.setElementsListener(QueryTypes.all, _onAllLibraryElement);
  }

  ///type : [List<DocumentSnapshot>]
  void _onAllLibraryElement(var snapshots) {
     _libraryData = [];
    for (DocumentSnapshot snap in snapshots)
      _libraryData.addAll(snap.data.values);

    if (_libraryData != null && _libraryData.length > 0)
      _dataState = States.Added;
    else
      _dataState = States.Empty;
    notifyListeners();
  }

  List _getRecentElements() {
    return _libraryData..sort((a, b) => a["creation_date"] > b["creation_date"] ? 1 : -1);
  }
  List _getLastSeen() {
    return _libraryData.where((element) => element["seen"]).toList();
  }
  List _getToSee() {
    return _libraryData.where((element) => element["to_see"]).toList();
  }

  void confirmTransfertDB() {

  }

  void hideTransfertDB() {

  }

  void onDismissed() {
    _askTransferDbDismissed = true;
    notifyListeners();
  }

  void onDonateClick() async {
    String donateLink = await FireconfigQueries.donationLink;
    if (donateLink == null || donateLink.length == 0) {
      GlobalsFunc.snackBar(_context, "Erreur ! Vérifiez votre connexion internet");
      return;
    }
    print(donateLink);
    launch(donateLink);
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

  bool get isTransferDismissedHidden => _askTransferDbDismissed;

  int get carrouselLength => HomeCarrousels.values.length;
}