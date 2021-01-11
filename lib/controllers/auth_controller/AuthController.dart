import 'dart:async';

import 'package:Videotheque/api/FireauthQueries.dart';
import 'package:Videotheque/api/FireconfigQueries.dart';
import 'package:Videotheque/api/FirestoreQueries.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/utils/Singletons.dart';
import 'package:Videotheque/views/app_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends ChangeNotifier {
  BuildContext context;
  BuildContext scaffoldContext;
  AppView mainView;
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

  FireauthQueries fireauth = Singletons.instance<FireauthQueries>();
  FirestoreQueries firestore = Singletons.instance<FirestoreQueries>();
  FireconfigQueries fireconfig = Singletons.instance<FireconfigQueries>();

  AuthController(this.context, this.mainView);

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
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, 
        accessToken: googleAuth.accessToken
      );
      final User user = (await firebaseAuth.signInWithCredential(credential)).user;
      if (!await firestore.hasDB(user.uid)) {
        print("User created account, init DB");
        if (!await firestore.initDb()) {
          await user.delete();
          throw Exception();
        }
      }
      print("User signed in : ${user.displayName}");
    } on Exception {
      GlobalsFunc.snackBar(scaffoldContext, "Une erreur est apparu lors de la connexion via Google");
      return;
    }
    fireauth.setNoAccount(false);
    mainView.logged();
    Navigator.pushReplacementNamed(scaffoldContext, "/");
  }

  void onNoAccountPressed() {
    fireauth.setNoAccount(true);
    Navigator.pushReplacementNamed(scaffoldContext, "/");
  }

  void onConfirmButtonPress() async {
    List connectRes = [null, null, null];
    pendingTransfer = true;
    passwdError = null;
    emailError = null;
    notifyListeners();
    if (registerSelected) { //Register
      if (!formKey.currentState.validate())  {
        pendingTransfer = false;
        notifyListeners();
        return;
      }
      if(!await _register(emailController.text, passwdController.text, nameController.text))
        return;
    }
    //Connexion
    connectRes = await fireauth.connect(emailController.text, passwdController.text);
    print(connectRes);
    pendingTransfer = false;
    notifyListeners();
    emailError = connectRes[0];  
    passwdError = connectRes[1]; 
    if (connectRes[2]) GlobalsFunc.snackBar(scaffoldContext, "Erreur lors de la connexion.");
    //Si ya pas d'erreur
    if (connectRes[0] == null && connectRes[1] == null && !connectRes[2]) {
      fireauth.setNoAccount(false);
      mainView.logged();
      Navigator.pushReplacementNamed(scaffoldContext, "/");
    }
  }

  Future<bool> _register(String email, String pass, String name) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      final UserCredential authResult = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, 
        password: pass,
      );

      await authResult.user.updateProfile(displayName: name);

      print("User signed in : ${authResult.user.email}");
      if (!await firestore.initDb()) {
        await authResult.user.delete();
        return false;
      }
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
      pendingTransfer = false;
      notifyListeners();
      return false;
    } on Exception catch(e) {
      debugPrint(e.toString());
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
    return null;
  }

  List<bool> get selectedToggles => [registerSelected, !registerSelected];

}