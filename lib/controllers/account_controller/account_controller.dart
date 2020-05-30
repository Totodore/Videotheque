import 'dart:async';

import 'package:Videotheque/api/fireauthQueries.dart';
import 'package:Videotheque/api/fireconfigQueries.dart';
import 'package:Videotheque/api/firestoreQueries.dart';
import 'package:Videotheque/components/alert_dialog_component.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/utils.dart';
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

  AccountController(this.context) {
    fetchAccountData();
    fetchDbTransfer();
    Timer(Duration(milliseconds: 350), fetchAskCoffee); //On lance cette fonction avec un délai sinon on a un crash
    fetchStats();
  }

  void openSettings() {
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

  void fetchDbTransfer() async {
    dispTransferDb = await FireconfigQueries.canTransferDb;
    notifyListeners();
  }

  void fetchAskCoffee() async {
    donationLink = await FireconfigQueries.donationLink;
    if (donationLink != null && donationLink.length > 0)
      askCoffeeState = States.Added;
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

  void donateBtn() {
    print(donationLink);
    launch(donationLink);
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
    TextEditingController textController = TextEditingController(text: await FireauthQueries.getUserMail);
    await showDialog(context: context, builder: (BuildContext innerContext) {
      return AlertDialogComponent(
        mainColor: PersonView.baseColor,
        title: "Récupération des données",
        content: "Récupération des données depuis l'ancienne app, votre vidéothèque actuelle sera écrasée",
        buttonConfirm: "Récupérer mes données",
        inputWidget: Padding(
          padding: EdgeInsets.only(top: 20),
          child: TextField(
            controller: textController,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: GlobalsColor.darkGreen),
              labelText: "Mail de votre ancien compte",
              contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(3)),
                borderSide: BorderSide(
                  color: GlobalsColor.darkGreen,
                  width: 2,
                  style: BorderStyle.solid
                )
              ),
            ),
          ),
        ),
        buttonAbort: "Annuler",
        onConfirmed: () async {  //On confirm
          String mail = textController.text;
          Navigator.pop(innerContext);
          var res = await Utils.checkOldAccount(mail);
          if (res is String) {
            GlobalsFunc.snackBar(context, "Votre compte à bien été trouvé, récupération des données en cours, Veuillez patienter...");
            if(await FirestoreQueries.transferDb(await Utils.getOldAccountDb(res))) {
              GlobalsFunc.snackBar(context, "Vos données ont bien été récupérées");
              fetchStats();
            }
            else 
              GlobalsFunc.snackBar(context, "Une erreur est apparue lors de la récupération de vos données");
          } else GlobalsFunc.snackBar(context, "Imposible de trouver une base de données correspondant à ${textController.text}");
        },
        onAbort: () { //On abort
          Navigator.pop(innerContext);
        },
      );
    });
  }


  void changePassword() async {
    TextEditingController textController = TextEditingController();
    await showDialog(context: context, builder: (BuildContext innerContext) {
      return AlertDialogComponent(
        mainColor: GlobalsColor.darkGreen,
        title: "Changement de mot de passe",
        content: "Veuillez rentrer votre nouveau mot de passe",
        buttonConfirm: "Changer mon mot de passe",
        inputWidget: Padding(
          padding: EdgeInsets.only(top: 20),
          child: TextField(
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            controller: textController,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: GlobalsColor.darkGreen),
              labelText: "Nouveau mot de passe",
              contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(3)),
                borderSide: BorderSide(
                  color: GlobalsColor.darkGreen,
                  width: 2,
                  style: BorderStyle.solid
                )
              ),
            ),
          ),
        ),
        buttonAbort: "Annuler",
        onConfirmed: () async {  //On confirm
          String pass = textController.text;
          Navigator.pop(innerContext);
          String res = await FireauthQueries.setUserPass(pass);
          if (res == null)
            GlobalsFunc.snackBar(context, "Votre mot de passe à bien été modifié");
          else
            GlobalsFunc.snackBar(context, res);
        },
        onAbort: () { //On abort
          Navigator.pop(innerContext);
        },
      );
    });
  }

  
  void changeMail() async {
    TextEditingController textController = TextEditingController();
    await showDialog(context: context, builder: (BuildContext innerContext) {
      return AlertDialogComponent(
        mainColor: GlobalsColor.darkGreen,
        title: "Changement d'email",
        content: "Veuillez rentrer votre nouveau mail",
        buttonConfirm: "Changer mon email",
        inputWidget: Padding(
          padding: EdgeInsets.only(top: 20),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            controller: textController,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: GlobalsColor.darkGreen),
              labelText: "Nouvel email",
              contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(3)),
                borderSide: BorderSide(
                  color: GlobalsColor.darkGreen,
                  width: 2,
                  style: BorderStyle.solid
                )
              ),
            ),
          ),
        ),
        buttonAbort: "Annuler",
        onConfirmed: () async {  //On confirm
          String mail = textController.text;
          Navigator.pop(innerContext);
          String res = await FireauthQueries.setUserMail(mail);
          if (res == null) {
            fetchAccountData(true);
            GlobalsFunc.snackBar(context, "Votre email à bien été modifié");
          } else GlobalsFunc.snackBar(context, res);
        },
        onAbort: () { //On abort
          Navigator.pop(innerContext);
        },
      );
    });
  }

  void changeName() async {
    TextEditingController textController = TextEditingController();
    await showDialog(context: context, builder: (BuildContext innerContext) {
      return AlertDialogComponent(
        mainColor: GlobalsColor.darkGreen,
        title: "Changement de nom",
        content: "Veuillez rentrer votre nom",
        buttonConfirm: "Changer mon nom",
        inputWidget: Padding(
          padding: EdgeInsets.only(top: 20),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            controller: textController,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: GlobalsColor.darkGreen),
              labelText: "Nouveau nom",
              contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(3)),
                borderSide: BorderSide(
                  color: GlobalsColor.darkGreen,
                  width: 2,
                  style: BorderStyle.solid
                )
              ),
            ),
          ),
        ),
        buttonAbort: "Annuler",
        onConfirmed: () async {  //On confirm
          String name = textController.text;
          Navigator.pop(innerContext);
          await FireauthQueries.setUserName(name);
          fetchAccountData(true);
          GlobalsFunc.snackBar(context, "Votre nom à bien été modifié");
        },
        onAbort: () { //On abort
          Navigator.pop(innerContext);
        },
      );
    });
  }
}