import 'package:Videotheque/services/FirestoreQueries.dart';
import 'package:Videotheque/Globals.dart';
import 'package:Videotheque/utils/Singletons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireauthQueries {

  //Si l'utilisateur ne veut pas utiliser de compte
  Future<bool> get needSignIn async {
    bool noAccount = (await SharedPreferences.getInstance()).getBool("no_account") ?? false;
    if (noAccount) return false;  //Pas besoin de signIn
    User firebaseUser = FirebaseAuth.instance.currentUser;
    return firebaseUser == null;  //Besoin de signIn si c'est null
  }

  Future<bool> setNoAccount(bool noAccount) async {
    return (await SharedPreferences.getInstance()).setBool("no_account", noAccount);
  }

  //Return String error
  Future<List> connect(String mail, String pass) async {
    //[mail error, pass error, base error (bool)]
    List returner = [null, null, false];
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: mail, 
        password: pass
      );
    } on FirebaseAuthException catch(e) {
      switch (e.code) {
        case "invalid-email":
          returner[0] = "Email invalide";
          break;
        case "wrong-password":
          returner[1] = "Mot de passe invalide";
          break;
        case "user-not-found":
          returner[0] = "Email invalide";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          returner[0] = "Trop de tentatives de connexion";
          break;
        default: 
          returner[2] = true;
          break;
      }
    } on Exception catch(e) {
      print(e);
      returner[2] = true;
    }
    return returner;
  }
  Future<List> register(String mail, String pass, String name) async {
    //[mail error, pass error, base error (bool)]
    List returner = [null, null, false];
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      final UserCredential authResult = await firebaseAuth.createUserWithEmailAndPassword(
        email: mail, 
        password: pass,
      );
      await authResult.user.updateProfile(displayName: name);

      authResult.user.sendEmailVerification();
      print("User signed in : ${authResult.user.email}");
    } on FirebaseAuthException catch(e) {
      switch (e.code) {
        case "email-already-in-use":
          returner[0] = "L'email que vous avez entré existe déjà";
          break;
        case "weak-password":
          returner[1] = "Mot de passe trop faible";
          break;
        case "invalid-email":
          returner[0] = "Email invalide";
          break;
        default: returner[2] = true;
      } 
    } on Exception {
      returner[2] = true;
    } 
    return returner;
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<String> deleteAccount(String pass) async {
    String res;
    try {
      await (FirebaseAuth.instance.currentUser).delete();
    } on FirebaseAuthException catch(e) {
      if (e.code == "requires-recent-login") {
        connect(await userMail, pass);
        return deleteAccount(pass);
      }
      else res = "Une erreur est apparue lors de la suppression de votre compte";
    } on Exception {
      res = "Une erreur est apparue lors de la suppression de votre compte";
    }
    return res;
  }

  Future<String> get userId async => FirebaseAuth.instance.currentUser.uid;
  Future<String> get userName async => FirebaseAuth.instance.currentUser.displayName;
  Future<String> get userMail async => FirebaseAuth.instance.currentUser.email;
  Future<String> get userDate async => DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch((await Singletons.instance<FirestoreQueries>().getUserTimestamp)*1000));
  Future<bool> get userMailVerified async => FirebaseAuth.instance.currentUser.emailVerified;

  Future<void> sendMailConfirm(BuildContext context) async {
    try {
      await FirebaseAuth.instance.currentUser.sendEmailVerification();
    } on PlatformException {
      GlobalsFunc.snackBar(context, "Trop de mails envoyés, veuillez patienter un peu avant d'envoyer un nouveau mail de confirmation");
      return;
    }
    GlobalsFunc.snackBar(context, "Un email de vérification à bien été envoyé à ${FirebaseAuth.instance.currentUser.email}");
  }

  Future<void> setUserName(String name) async {
    await FirebaseAuth.instance.currentUser.updateProfile(displayName: name);
  }
  Future<String> setUserPass(String pass, String oldPass) async {
    String res;
    String mail = await userMail;
    try {
      await FirebaseAuth.instance.currentUser.updatePassword(pass);
    } on FirebaseAuthException catch(e) {
      switch (e.code) {
        case "weak-password":
          res = "Erreur : Mot de passe trop faible";
          break;
        case "requires-recent-login":
          await connect(mail, oldPass);
          return setUserPass(mail, pass); 
        default: res = "Erreur lors de la modification du mot de passe";
      } 
    } on Exception {
      res = "Erreur lors de la modification du mot de passe";
    }
    return res;
  }
  Future<String> setUserMail(String mail, String oldPass) async {
    String res;
    String oldMail = await userMail;
    try {
      User user = FirebaseAuth.instance.currentUser;
      await user.updateEmail(mail);
    } on FirebaseAuthException catch(e) {
      switch (e.code) {
        case "requires-recent-login":
          await connect(oldMail, oldPass);
          return setUserMail(mail, oldPass);
        case "email-already-in-use":
          res = "Erreur : Cet email est déjà utilisé";
          break;
        case "invalid-email": 
          res = "Erreur : Email invalide";
          break;
        default:
          res = "Erreur lors de la modification du mail";
      }
    } on Exception {
      res = "Erreur lors de la modification du mail";
    }
    return res;
  }
  
  Future<void> reloadData() async => FirebaseAuth.instance.currentUser.reload();

}