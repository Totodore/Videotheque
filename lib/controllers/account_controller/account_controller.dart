import 'package:Videotheque/api/fireauthQueries.dart';
import 'package:Videotheque/api/firestoreQueries.dart';
import 'package:Videotheque/components/TransferDBDialogComponent.dart';
import 'package:Videotheque/components/alert_dialog_component.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/utils/utils.dart';
import 'package:Videotheque/views/account_view/components/ChangeMailComponent.dart';
import 'package:Videotheque/views/account_view/components/ChangeNameComponent.dart';
import 'package:Videotheque/views/account_view/components/ChangePasswordComponent.dart';
import 'package:Videotheque/views/person_view/person_view.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountController extends ChangeNotifier {
  BuildContext context;
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

  AccountController(this.context) {
    fetchAccountData();
    fetchStats();
  }

  void fetchAccountData([reload = false]) async {
    accountDataState = States.Loading;
    notifyListeners();
    if (reload)
      await FireauthQueries.reloadData();
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

  void onDispStats(bool disp) {
    dispStats = disp;
    notifyListeners();
  }

  void logout() async {
    await FireauthQueries.logout();
    Navigator.of(context).pushReplacementNamed("/auth");
  }

  void foundBug() {
    launch("mailto:prevottheodore@gmail.com");
  }

  void removeAccount() async {
    BuildContext scaffoldContext = context;
    await showDialog(context: context, builder: (BuildContext context) {
      return AlertDialogComponent(
        title: "Supprimer mon compte",
        content: "Etes-vous sur de supprimer votre compte ? Vous perdrez la totalité de vos données.",
        buttonConfirm: "Supprimer mon compte",
        buttonAbort: "Annuler",
        onConfirmed: () async {  //On confirm
          Navigator.pop(context);
          String res = await FireauthQueries.deleteAccount();
          if (res == null)
            Navigator.pushReplacementNamed(context, "/auth");
          else
            GlobalsFunc.snackBar(scaffoldContext, res);
        },
        onAbort: () { //On abort
          Navigator.pop(context);
        },
        mainColor: PersonView.baseColor,
      );
    });
  }
  void removeData() async {
    await showDialog(context: context, builder: (BuildContext innerContext) {
      return AlertDialogComponent(
        title: "Supprimer mes données",
        content: "Etes-vous sur de supprimer vos données ?",
        buttonConfirm: "Supprimer mes données",
        buttonAbort: "Annuler",
        onConfirmed: () async {  //On confirm
          Navigator.pop(innerContext);
          if (await FirestoreQueries.initDb()) {
            GlobalsFunc.snackBar(context, "Vos données ont bien été supprimées");
            fetchStats();
          } else GlobalsFunc.snackBar(context, "Erreur lors de la suppression de vos données");
        },
        onAbort: () { //On abort
          Navigator.pop(innerContext);
        },
        mainColor: PersonView.baseColor,
      );
    });
  }
  void transferDb() async {
    _textEditingController = TextEditingController(text: await FireauthQueries.getUserMail);
    showDialog(context: context, builder: (BuildContext innerContext) =>
     TransferDBDialogComponent(_abortPopup, _confirmTransferDB, _textEditingController, innerContext));
  }

  void _confirmTransferDB(context) async {
    String mail = _textEditingController.text;
    Navigator.pop(context);
    var res = await Utils.checkOldAccount(mail);
    if (res is String) {
      GlobalsFunc.snackBar(context, "Votre compte à bien été trouvé, récupération des données en cours, Veuillez patienter...");
      if(await FirestoreQueries.transferDb(await Utils.getOldAccountDb(res))) {
        GlobalsFunc.snackBar(context, "Vos données ont bien été récupérées");
        fetchStats();
      }
      else 
        GlobalsFunc.snackBar(context, "Une erreur est apparue lors de la récupération de vos données");
    } else GlobalsFunc.snackBar(context, "Imposible de trouver une base de données correspondant à ${_textEditingController.text}");
  }

  void _abortPopup(context) => Navigator.pop(context);


  void changePassword() async {
    _textEditingController = TextEditingController();
    _textEditingController2 = TextEditingController();
    showDialog(context: context, builder: (BuildContext innerContext) =>
      ChangePasswordComponent(_confirmPasswordChange, _abortPopup, _textEditingController, _textEditingController2, innerContext));
  }

  void _confirmPasswordChange(BuildContext context) async {
    String pass = _textEditingController.text;
    String newPass = _textEditingController2.text; 
    Navigator.pop(context);
    String res = await FireauthQueries.setUserPass(pass);
    if (res == null)
      GlobalsFunc.snackBar(context, "Votre mot de passe à bien été modifié");
    else
      GlobalsFunc.snackBar(context, res);
  }

  
  void changeMail() async {
    _textEditingController = TextEditingController();
    _textEditingController2 = TextEditingController();
    await showDialog(context: context, builder: (BuildContext innerContext) =>
      ChangeMailComponent(_onConfirmChangeMail, _abortPopup, _textEditingController, _textEditingController2, context));
  }

  void _onConfirmChangeMail(BuildContext context) async {
    String mail = _textEditingController.text;
    Navigator.pop(context);
    String res = await FireauthQueries.setUserMail(mail);
    if (res == null) {
      fetchAccountData(true);
      GlobalsFunc.snackBar(context, "Votre email à bien été modifié");
    } else GlobalsFunc.snackBar(context, res);
  }

  void changeName() async {
    _textEditingController = TextEditingController();
    await showDialog(context: context, builder: (BuildContext innerContext) =>
      ChangeNameComponent(_onConfirmChangeName, _abortPopup, _textEditingController, innerContext));
  }

  void _onConfirmChangeName(BuildContext context) async {
    String name = _textEditingController.text;
    Navigator.pop(context);
    await FireauthQueries.setUserName(name);
    fetchAccountData(true);
    GlobalsFunc.snackBar(context, "Votre nom à bien été modifié");
  }
}