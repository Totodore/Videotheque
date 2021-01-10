import 'package:Videotheque/api/fireauthQueries.dart';
import 'package:Videotheque/api/fireconfigQueries.dart';
import 'package:Videotheque/api/FirestoreQueries.dart';
import 'package:Videotheque/components/alert_dialog_component.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/views/account_view/components/ChangeMailComponent.dart';
import 'package:Videotheque/views/account_view/components/ChangeNameComponent.dart';
import 'package:Videotheque/views/account_view/components/ChangePasswordComponent.dart';
import 'package:Videotheque/views/account_view/components/RemoveAccountComponent.dart';
import 'package:Videotheque/views/person_view/person_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountController extends ChangeNotifier {
  BuildContext _context;
  String name = "";
  String mail = "";
  String accountCreation = "";
  String donationLink = "";
  
  bool dispTransferDb = false;
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

  AccountController(this._context) {
    fetchAccountData();
    fetchStats();
    fetchTransferDB();
  }

  void fetchAccountData() async {
    accountDataState = States.Loading;
    notifyListeners();
    name = await FireauthQueries.getUserName;
    mail = await FireauthQueries.getUserMail;
    accountCreation = await FireauthQueries.getUserDate;
    if (name != null && mail != null && accountCreation != null)
      accountDataState = States.Added;
    notifyListeners();
  }

  void fetchStats() async {
    statsStates = States.Loading;
    notifyListeners();
    List<int> statsNumberGeneral = await FirestoreQueries.statNumberGeneral; 
    statNumberMovies = await FirestoreQueries.statNumberEl(QueryTypes.movie);
    statNumberPeople = await FirestoreQueries.statNumberEl(QueryTypes.person);
    statNumberTv = await FirestoreQueries.statNumberEl(QueryTypes.tv);
    statNumberCollection = await FirestoreQueries.statNumberEl(QueryTypes.collection);
    statNumberFav = statsNumberGeneral[2];
    statNumberToSee = statsNumberGeneral[1];
    statNumberSeen = statsNumberGeneral[0];
    statNumberTags = await FirestoreQueries.statNumberTags;
    statsStates = States.Added;
    notifyListeners();
  }

  void fetchTransferDB() async {
    dispTransferDb = await FireconfigQueries.canTransferDb;
    notifyListeners();
  }

  void onDispStats(bool disp) {
    dispStats = disp;
    notifyListeners();
  }

  void logout() async {
    await FireauthQueries.logout();
    Navigator.of(_context).pushReplacementNamed("/auth");
  }

  void foundBug() {
    launch("mailto:prevottheodore@gmail.com");
  }

  void removeAccount() async {
    _textEditingController = TextEditingController();
    showAnimatedDialog(
      animationType: DialogTransitionType.slideFromBottom,
      duration: const Duration(milliseconds: 200),
      context: _context, 
      barrierDismissible: true,
      builder: (BuildContext context) => 
        RemoveAccountComponent(_onConfirmRemoveAccount, _abortPopup, _textEditingController, _context)
      );
  }

  void removeData() {
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
          if (await FirestoreQueries.initDb()) {
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

  void changePassword() {
    _textEditingController = TextEditingController();
    _textEditingController2 = TextEditingController();
    showAnimatedDialog(
      animationType: DialogTransitionType.slideFromBottom,
      duration: const Duration(milliseconds: 200),
      context: _context, 
      barrierDismissible: true,
      builder: (BuildContext innerContext) =>
        ChangePasswordComponent(_confirmPasswordChange, _abortPopup, _textEditingController, _textEditingController2, innerContext)
    );
  }

  
  void changeMail() {
    _textEditingController = TextEditingController();
    _textEditingController2 = TextEditingController();
    showAnimatedDialog(
      animationType: DialogTransitionType.slideFromBottom,
      duration: const Duration(milliseconds: 200),
      context: _context, 
      barrierDismissible: true,
      builder: (BuildContext innerContext) =>
        ChangeMailComponent(_onConfirmChangeMail, _abortPopup, _textEditingController, _textEditingController2, _context)
      );
  }

  void changeName() {
    _textEditingController = TextEditingController();
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
    String res = await FireauthQueries.deleteAccount(_textEditingController.text);
    if (res == null)
      Navigator.pushReplacementNamed(context, "/auth");
    else
      GlobalsFunc.snackBar(_context, res);
  }

  void _confirmPasswordChange(BuildContext context) async {
    String pass = _textEditingController.text;
    String newPass = _textEditingController2.text;
    Navigator.pop(context);
    String res = await FireauthQueries.setUserPass(newPass, pass);
    if (res == null)
      GlobalsFunc.snackBar(_context, "Votre mot de passe à bien été modifié");
    else
      GlobalsFunc.snackBar(_context, res);
  }

  void _onConfirmChangeMail(BuildContext context) async {
    String pass = _textEditingController.text;
    String email = _textEditingController2.text;
    Navigator.pop(context);
    String res = await FireauthQueries.setUserMail(email, pass);
    if (res == null) {
      GlobalsFunc.snackBar(context, "Votre email à bien été modifié");
      mail = email;
      notifyListeners();
    } else GlobalsFunc.snackBar(context, res);
  }

  void _onConfirmChangeName(BuildContext context) async {
    String username = _textEditingController.text;
    Navigator.pop(context);
    await FireauthQueries.setUserName(username);
    GlobalsFunc.snackBar(_context, "Votre nom à bien été modifié");
    name = username;
    notifyListeners();
  }

  set context(BuildContext context) => _context = context; 
}