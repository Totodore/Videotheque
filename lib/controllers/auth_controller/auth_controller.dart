import 'dart:async';
import 'dart:convert';

import 'package:Videotheque/components/alert_dialog_component.dart';
import 'package:Videotheque/api/firestoreQueries.dart';
import 'package:Videotheque/api/FireauthQueries.dart';
import 'package:Videotheque/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:Videotheque/utils/utils.dart';
class AuthController extends ChangeNotifier {
  BuildContext context;
  BuildContext scaffoldContext;

  final crossFadeDuration = Duration(milliseconds: 300);
  final formKey = GlobalKey<FormState>();
  bool launchAnimation = false;
  bool registerSelected = true;
  bool showPassword = false;
  bool showConfirmPassword = false;
  bool pendingTransfer = false;

  TextEditingController passwdController = TextEditingController();
  TextEditingController passwdConfirmController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  String passwdError;
  String emailError;

  AuthController(this.context);

  void onToggleButtonsPressed(int index) {
    index == 1 && registerSelected || index == 0 && !registerSelected ? registerSelected = !registerSelected : null;
    notifyListeners();
  }

  void onShowPasswordPressed() {
    showPassword = !showPassword;
    notifyListeners();
  }
  void onShowConfirmPasswordPressed() {
    showConfirmPassword = !showConfirmPassword;
    notifyListeners();
  }

  void onConnectGooglePressed() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken, 
      accessToken: googleAuth.accessToken
    );
    final FirebaseUser user = (await firebaseAuth.signInWithCredential(credential)).user;
    print("User signed in : ${user.displayName}");
  }

  void onNoAccountPressed() {
    FireauthQueries.setNoAccount(true);
    Navigator.pushReplacementNamed(context, "/");
  }

  void onConfirmButtonPress() async {
    pendingTransfer = true;
    passwdError = null;
    emailError = null;
    notifyListeners();
    Map db;
    if (registerSelected) { //Register
      if (!formKey.currentState.validate())
        return;
      bool res = await _register(emailController.text, passwdController.text, nameController.text);
       //On check si il existe un ancien compte
      var id = await Utils.checkOldAccount(emailController.text);
      //si oui on à l'id du compte et on charge l'ancienne bdd
      if (id is String && res) {
        if (await _askForGettingOldAccount(id)) {
          GlobalsFunc.snackBar(scaffoldContext, "Chargement de la base de donnée...");
          db = await Utils.getOldAccountDb(id);
        }
      }
      if (res && db != null)
        if (!await FirestoreQueries.transferDb(db))
          GlobalsFunc.snackBar(scaffoldContext, "Erreur lors du transfert de vos données, veuillez contacter l'administrateur");
        else {
          GlobalsFunc.snackBar(scaffoldContext, "Votre compte à bien été transféré !");
          registerSelected = false;
        }
      else if (res && await FirestoreQueries.initDb()) {
        GlobalsFunc.snackBar(scaffoldContext, "Votre compte à bien été créé !");
        registerSelected = false;
      }
    } else {  //Connexion
      List res = await FireauthQueries.connect(emailController.text, passwdController.text);
      emailError = res[0];  
      passwdError = res[1]; 
      if (res[2]) GlobalsFunc.snackBar(scaffoldContext, "Erreur lors de la connexion.");
      //Si ya pas d'erreur
      if (res[0] == null && res[1] == null || !res[2]) {
        FireauthQueries.setNoAccount(false);
        Navigator.pushReplacementNamed(context, "/");
      }
    }
    pendingTransfer = false;
    notifyListeners();
  }

  Future<bool> _register(String email, String pass, String name) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      final AuthResult authResult = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, 
        password: pass,
      );
      final UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = name;

      await authResult.user.updateProfile(userUpdateInfo);

      print("User signed in : ${authResult.user.email}");
    } on PlatformException catch(e) {
      switch (e.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
          emailError = "L'email que vous avez entré existe déjà";
          break;
        case "ERROR_WEAK_PASSWORD":
          passwdError = "Mot de passe trop faible";
          break;
        case "ERROR_INVALID_EMAIL":
          emailError = "Email invalide";
          break;
        default: GlobalsFunc.snackBar(scaffoldContext, "Erreur lors de votre inscription.");
      } 
      notifyListeners();
      return false;
    } on Exception catch(e) {
      GlobalsFunc.snackBar(scaffoldContext, "Erreur lors de votre inscription.");
      return false;
    }
    return true;
  }

  String passwdValidator(String passwd) {
    if (passwdConfirmController.text != passwd)
      return "Les mots de passe ne concordent pas";
    if (passwdConfirmController.text.length < 6)
      return "Mot de passe pas suffisament sécurisé";
  }

  Future<bool> _askForGettingOldAccount(String id) async {
    bool result = false;
    await showDialog(context: context, builder: (BuildContext context) {
      return AlertDialogComponent(
        title: "Ancien compte",
        content: "Nous avons trouvé un ancien compte correspondant à ce mail et ce mot de passe, voulez vous récupérer sa base de données ? Cela necessite une connexion internet stable, vous pourrez à tout moment faire le transfert dans l'onglet Compte",
        buttonConfirm: "Transférer le compte",
        buttonAbort: "Non merci",
        onConfirmed: () {  //On confirm
          result = true;
          Navigator.pop(context);
        }, 
        onAbort: () { //On abort
          result = false;
          Navigator.pop(context);
        },
        mainColor: GlobalsColor.darkGreen
      );
    });
    return result;
  }

  List<bool> get selectedToggles => [registerSelected, !registerSelected];

}