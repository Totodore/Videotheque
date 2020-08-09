import 'package:Videotheque/api/fireauthQueries.dart';
import 'package:Videotheque/api/fireconfigQueries.dart';
import 'package:Videotheque/api/firestoreQueries.dart';
import 'package:Videotheque/components/TransferDBDialogComponent.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/utils/customChangeNotifier.dart';
import 'package:Videotheque/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends CustomChangeNotifier {
  final BuildContext _context;
  List<HomeCarrousels> _toDisplayCarroussels = List.from(HomeCarrousels.values)..shuffle();
  List _libraryData = [];
  bool _askTransferDbDismissed = false;
  bool _askTransferDB = false;
  bool _isMailConfirmed = true;
  String _mail = "";
  TextEditingController _textEditingController;

  States _dataState = States.Loading;

  HomeController(this._context) {
    _getLibrary();
  }


  void _getLibrary() {
    _dataState = States.Loading;
    FirestoreQueries.setElementsListener(QueryTypes.all, _onAllLibraryElement);
  }

  ///type : [List<DocumentSnapshot>]
  void _onAllLibraryElement(var snapshots) async {
     _libraryData = [];
    for (DocumentSnapshot snap in snapshots)
      _libraryData.addAll(snap.data.values);

    try {
      _askTransferDB = !(await SharedPreferences.getInstance()).containsKey("hideTransferDB") ?? true;
      _isMailConfirmed = await FireauthQueries.getUserMailVerified;
      print(_isMailConfirmed);
      if (!_isMailConfirmed) _mail = await FireauthQueries.getUserMail;
    } on Exception {
      _askTransferDB = true;
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
    return _libraryData..sort((a, b) => (a["creation_date"] ?? 0) > (b["creation_date"] ?? 0) ? 1 : -1);
  }
  List _getLastSeen() {
    return _libraryData.where((element) => element["seen"]).toList()
      ..sort((a, b) => (a["seen_timestamp"] ?? 0) < (b["seen_timestamp"] ?? 0) ? 1 : -1);
  }
  List _getToSee() {
    return _libraryData.where((element) => element["to_see"]).toList()
      ..sort((a, b) => (a["to_see_timestamp"] ??= 0) < (b["to_see_timestamp"] ?? 0) ? 1 : -1);;
  }

  Function sendMailConfirm = FireauthQueries.sendMailConfirm;

  void confirmTransfertDB() async {
    _textEditingController = TextEditingController(text: await FireauthQueries.getUserMail);
    showDialog(context: _context, child: TransferDBDialogComponent(
      _onDialogClose, 
      _onDialogConfirm,
      _textEditingController, 
      _context)
    );
  }

  void _onDialogClose(BuildContext context) => Navigator.pop(context);

  void _onDialogConfirm(BuildContext context) {
    Navigator.pop(context);
    Utils.transferDB(_textEditingController.text, _context);
  } 

  void hideTransfertDB() async {
    _askTransferDbDismissed = true;
    notifyListeners();
    (await SharedPreferences.getInstance()).setBool("hideTransferDB", true);
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

  String get userMail => _mail;

  bool get isLoading => _dataState == States.Loading;
  bool get hasNoContent => _dataState == States.Empty;

  bool get isTransferDismissedHidden => _askTransferDbDismissed;
  bool get askTransferDB => _askTransferDB;

  bool get mailConfirmed => _isMailConfirmed;
  int get carrouselLength => HomeCarrousels.values.length;
}