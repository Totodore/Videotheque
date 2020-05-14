import 'package:Videotheque/api/firestoreQueries.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireauthQueries {
  
  //Si l'utilisateur ne veut pas utiliser de compte
  static Future<bool> get needSignIn async {
    bool noAccount = (await SharedPreferences.getInstance()).getBool("no_account") ?? false;
    if (noAccount) return false;  //Pas besoin de signIn
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    return firebaseUser == null;  //Besoin de signIn si c'est null
  }

  static Future<bool> setNoAccount(bool noAccount) async {
    return (await SharedPreferences.getInstance()).setBool("no_account", noAccount);
  } 

  //Return String error
  static Future<List> connect(String mail, String pass) async {
    //[mail error, pass error, base error (bool)]
    List returner = [null, null, false];
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: mail, 
        password: pass
      );
    } on PlatformException catch(e) {
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          returner[0] = "Email invalide";
          break;
        case "ERROR_WRONG_PASSWORD":
          returner[1] = "Mot de passe invalide";
          break;
        case "ERROR_USER_NOT_FOUND":
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
  static Future<List> register(String mail, String pass, String name) async {
    //[mail error, pass error, base error (bool)]
    List returner = [null, null, false];
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      final AuthResult authResult = await firebaseAuth.createUserWithEmailAndPassword(
        email: mail, 
        password: pass,
      );
      final UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = name;

      await authResult.user.updateProfile(userUpdateInfo);
      print("User signed in : ${authResult.user.email}");
    } on PlatformException catch(e) {
      switch (e.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
          returner[0] = "L'email que vous avez entré existe déjà";
          break;
        case "ERROR_WEAK_PASSWORD":
          returner[1] = "Mot de passe trop faible";
          break;
        case "ERROR_INVALID_EMAIL":
          returner[0] = "Email invalide";
          break;
        default: returner[2] = true;
      } 
    } on Exception catch(e) {
      returner[2] = true;
    } 
    return returner;
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<String> deleteAccount() async {
    String res;
    try {
      await (await FirebaseAuth.instance.currentUser()).delete();
    } on PlatformException catch(e) {
      if (e.code == "ERROR_REQUIRES_RECENT_LOGIN") {
        res = "Erreur : Cela fait trop trop longtemps que vous ne vous êtes pas connecté, veuilliez vous déconnecter puis vous reconnecter pour pouvoir supprimer votre compte.";
      }
      else res = "Une erreur est apparue lors de la suppression de votre compte";
    } on Exception {
      res = "Une erreur est apparue lors de la suppression de votre compte";
    }
    return res;
  }

  static Future<String> get getUserId async => (await FirebaseAuth.instance.currentUser()).uid;
  static Future<String> get getUserName async => (await FirebaseAuth.instance.currentUser()).displayName;
  static Future<String> get getUserMail async => (await FirebaseAuth.instance.currentUser()).email;
  static Future<String> get getUserDate async => DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch((await FirestoreQueries.getUserTimestamp)*1000));
  
  static Future<void> setUserName(String name) async {
    UserUpdateInfo infos = UserUpdateInfo();
    infos.displayName = name;
    (await FirebaseAuth.instance.currentUser()).updateProfile(infos);
  }
  static Future<String> setUserPass(String pass) async {
    String res;
    try {
      await (await FirebaseAuth.instance.currentUser()).updatePassword(pass);
    } on PlatformException catch(e) {
      switch (e.code) {
        case "ERROR_WEAK_PASSWORD":
          res = "Erreur : Mot de passe trop faible";
          break;
        case "ERROR_REQUIRES_RECENT_LOGIN":
          res = "Erreur : Cela fait trop trop longtemps que vous ne vous êtes pas connecté, veuilliez vous déconnecter puis vous reconnecter pour pouvoir changer votre mot de passe";
          break;
        default: res = "Erreur lors de la modification du mot de passe";
      } 
    } on Exception {
      res = "Erreur lors de la modification du mot de passe";
    }
    return res;
  }
  static Future<String> setUserMail(String mail) async {
    String res;
    try {
      await (await FirebaseAuth.instance.currentUser()).updateEmail(mail);
    } on PlatformException catch(e) {
      switch (e.code) {
        case "ERROR_REQUIRES_RECENT_LOGIN":
          res = "Erreur : Cela fait trop trop longtemps que vous ne vous êtes pas connecté, veuilliez vous déconnecter puis vous reconnecter pour pouvoir changer votre email";
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
          res = "Erreur : Cet email est déjà utilisé";
          break;
        case "ERROR_INVALID_CREDENTIAL": 
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
  static Future<void> reloadData() async => (await FirebaseAuth.instance.currentUser()).reload();
}