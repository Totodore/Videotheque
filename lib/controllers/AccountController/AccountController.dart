import 'package:Videotheque/services/FireauthQueries.dart';
import 'package:Videotheque/services/FireconfigQueries.dart';
import 'package:Videotheque/services/FirestoreQueries.dart';
import 'package:Videotheque/components/alert_dialog_component.dart';
import 'package:Videotheque/Globals.dart';
import 'package:Videotheque/services/Preferences.dart';
import 'package:Videotheque/utils/Singletons.dart';
import 'package:Videotheque/views/AccountView/components/ChangeMailComponent.dart';
import 'package:Videotheque/views/AccountView/components/ChangeNameComponent.dart';
import 'package:Videotheque/views/AccountView/components/ChangePasswordComponent.dart';
import 'package:Videotheque/views/AccountView/components/RemoveAccountComponent.dart';
import 'package:Videotheque/views/person_view/PersonView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:random_color/random_color.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountController extends ChangeNotifier {
  BuildContext _context;
  String name = "";
  String mail = "";
  String accountCreation = "";
  String donationLink = "";

  bool dispStats = false;
  States askCoffeeState = States.Nothing;
  States accountDataState = States.Nothing;
  States statsStates = States.Nothing;

  int statNumberMovies = 0;
  int statNumberPeople = 0;
  int statNumberTv = 0;
  int statNumberCollection = 0;
  int statNumberFav = 0;
  int statNumberToSee = 0;
  int statNumberSeen = 0;
  int statNumberTags = 0;

  TextEditingController _textEditingController;
  TextEditingController _textEditingController2;

  FireauthQueries fireauth = Singletons.instance<FireauthQueries>();
  FirestoreQueries firestore = Singletons.instance<FirestoreQueries>();
  FireconfigQueries fireconfig = Singletons.instance<FireconfigQueries>();
  Preferences prefs = Singletons.instance<Preferences>();

  bool _dispSearchOptions = false;

  final List<List<Color>> gradients = List.generate(6, (index) => List.generate(2, (index) => RandomColor().randomColor()));

  AccountController(this._context) {
    fetchAccountData();
    fetchStats();
  }

  void fetchAccountData() async {
    accountDataState = States.Loading;
    notifyListeners();
    name = await fireauth.userName;
    mail = await fireauth.userMail;
    accountCreation = await fireauth.userDate;
    if (name != null && mail != null && accountCreation != null)
      accountDataState = States.Added;
    notifyListeners();
  }

  void fetchStats() async {
    statsStates = States.Loading;
    notifyListeners();
    List<int> statsNumberGeneral = await firestore.statNumberGeneral; 
    statNumberMovies = await firestore.statNumberEl(QueryTypes.movie);
    statNumberPeople = await firestore.statNumberEl(QueryTypes.person);
    statNumberTv = await firestore.statNumberEl(QueryTypes.tv);
    statNumberCollection = await firestore.statNumberEl(QueryTypes.collection);
    statNumberFav = statsNumberGeneral[2];
    statNumberToSee = statsNumberGeneral[1];
    statNumberSeen = statsNumberGeneral[0];
    statNumberTags = await firestore.statNumberTags;
    statsStates = States.Added;
    notifyListeners();
  }

  void onDispStats(bool disp) {
    dispStats = disp;
    notifyListeners();
  }

  void logout() async {
    await fireauth.logout();
    Navigator.of(_context).pushReplacementNamed("/auth");
  }

  void foundBug() {
    launch("mailto:prevottheodore@gmail.com");
  }

  void removeAccount() async {
    _textEditingController = TextEditingController();
    await Future.delayed(const Duration(milliseconds: 200));
    showAnimatedDialog(
      animationType: DialogTransitionType.slideFromBottom,
      duration: const Duration(milliseconds: 200),
      context: _context, 
      barrierDismissible: true,
      builder: (BuildContext context) => 
        RemoveAccountComponent(_onConfirmRemoveAccount, _abortPopup, _textEditingController, _context)
      );
  }

  void removeData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    showAnimatedDialog(
      animationType: DialogTransitionType.slideFromBottom,
      duration: const Duration(milliseconds: 200),
      context: _context, 
      barrierDismissible: true,
      builder: (BuildContext innerContext) => AlertDialogComponent(
        title: "Supprimer mes données",
        content: "Etes-vous sur de supprimer vos données ?",
        buttonConfirm: "Supprimer mes données",
        buttonAbort: "Annuler",
        onConfirmed: () async {  //On confirm
          Navigator.pop(innerContext);
          if (await firestore.initDb()) {
            GlobalsFunc.snackBar(_context, "Vos données ont bien été supprimées");
            fetchStats();
          } else GlobalsFunc.snackBar(_context, "Erreur lors de la suppression de vos données");
        },
        onAbort: () { //On abort
          Navigator.pop(innerContext);
        },
        mainColor: PersonView.baseColor,
      ));
  }

  void changePassword() async {
    _textEditingController = TextEditingController();
    _textEditingController2 = TextEditingController();
    await Future.delayed(const Duration(milliseconds: 200));
    showAnimatedDialog(
      animationType: DialogTransitionType.slideFromBottom,
      duration: const Duration(milliseconds: 200),
      context: _context, 
      barrierDismissible: true,
      builder: (BuildContext innerContext) =>
        ChangePasswordComponent(_confirmPasswordChange, _abortPopup, _textEditingController, _textEditingController2, innerContext)
    );
  }

  
  void changeMail() async {
    _textEditingController = TextEditingController();
    _textEditingController2 = TextEditingController();
    await Future.delayed(const Duration(milliseconds: 200));
    showAnimatedDialog(
      animationType: DialogTransitionType.slideFromBottom,
      duration: const Duration(milliseconds: 200),
      context: _context, 
      barrierDismissible: true,
      builder: (BuildContext innerContext) =>
        ChangeMailComponent(_onConfirmChangeMail, _abortPopup, _textEditingController, _textEditingController2, _context)
      );
  }

  void changeName() async {
    _textEditingController = TextEditingController();
    await Future.delayed(const Duration(milliseconds: 200));
    showAnimatedDialog(
      animationType: DialogTransitionType.slideFromBottom,
      duration: const Duration(milliseconds: 200),
      context: _context, 
      barrierDismissible: true,
      builder: (BuildContext innerContext) =>
        ChangeNameComponent(_onConfirmChangeName, _abortPopup, _textEditingController, innerContext)
      );
  }

  void _abortPopup(context) => Navigator.pop(context);

  void _onConfirmRemoveAccount(BuildContext context) async {
    Navigator.pop(context);
    String res = await fireauth.deleteAccount(_textEditingController.text);
    if (res == null)
      Navigator.pushReplacementNamed(context, "/auth");
    else
      GlobalsFunc.snackBar(_context, res);
  }

  void _confirmPasswordChange(BuildContext context) async {
    String pass = _textEditingController.text;
    String newPass = _textEditingController2.text;
    Navigator.pop(context);
    String res = await fireauth.setUserPass(newPass, pass);
    if (res == null)
      GlobalsFunc.snackBar(_context, "Votre mot de passe à bien été modifié");
    else
      GlobalsFunc.snackBar(_context, res);
  }

  void _onConfirmChangeMail(BuildContext context) async {
    String pass = _textEditingController.text;
    String email = _textEditingController2.text;
    Navigator.pop(context);
    String res = await fireauth.setUserMail(email, pass);
    if (res == null) {
      GlobalsFunc.snackBar(context, "Votre email à bien été modifié");
      mail = email;
      notifyListeners();
    } else GlobalsFunc.snackBar(context, res);
  }

  void _onConfirmChangeName(BuildContext context) async {
    String username = _textEditingController.text;
    Navigator.pop(context);
    await fireauth.setUserName(username);
    GlobalsFunc.snackBar(_context, "Votre nom à bien été modifié");
    name = username;
    notifyListeners();
  }

  set newSearchUI(bool val) {
    prefs.newSearchUI = val;
    notifyListeners();
  }
  set dispSearchOptions(bool dispSearchOptions) {
    _dispSearchOptions = dispSearchOptions;
    notifyListeners();
  }

  bool get newSearchUI => prefs.newSearchUI;
  bool get dispSearchOptions => _dispSearchOptions;

  set context(BuildContext context) => _context = context;
}