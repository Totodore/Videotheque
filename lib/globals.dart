import 'package:Videotheque/tmdbQueries.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class GlobalsColor {
  static final darkGreen = Color(0xFF00574B);
  static final darkGreenDisabled = Color(0xFF00574B).withAlpha(100);
  static final green = Color(0xFF295f5f);
  static final fadedGreen = Color(0x6597C5A6);
  static final lightGreen = Color(0xFF008577);
  static final lightGreen2 = Color(0xFF5b9fae);
  static final lightBlue = Color(0xFFb5e2e2);
  static final darkGrey = Color(0xFF353535);

}
class GlobalsParam {
}

class GlobalsData {
  static Map genreList = Map();

  static const String apiKey = "a6499d6e1a486416773626640f79de9d";
  static const String lang = "fr-FR";
  static const String imgSize = "https://image.tmdb.org/t/p/w500/";
  static const String thumbImgSize = "https://image.tmdb.org/t/p/w92";
  static const String midThumbImgSize = "https://image.tmdb.org/t/p/w185";
}


class GlobalsMessage {
  static const String errorPassConnect = "Le mot de passe rentré n'existe pas";
  static const String errorUserConnect = "Le nom d'utilisateur rentré n'existe pas";
  static const String errorConnect = "Erreur lors de la tentative de connexion";
  static const String errorMail = "Erreur lors de la récupération du mail, veuillez recommencer dès que possible";
  static const String askMail = "Suite à une mise à jour il est maintenant requis d'entrer une adresse email valide pour ouvrir ou utiliser un compte, veuillez renseigner la votre ci-dessous. Elle vous permettra de récupérer votre mot de passe en cas de perte ou de changement majeurs de l'application.";
  static const String defaultError = "Une erreur est apparue lors de la récupération de vos données";

  static const String general = "Recherche générale";
  static const String movie = "Films";
  static const String person = "Personnes";
  static const String collection = "Collections";
  static const String tv = "Série TV";
  static const String companies = "Companies"; 

  static const List<Map<dynamic, dynamic>> chipData = [
    {
      "name": general,
      "type": QueryTypes.all
    },
    {
      "name": movie,
      "type": QueryTypes.movie,
    },
    {
      "name": person,
      "type": QueryTypes.person,
    },
    {
      "name": collection,
      "type": QueryTypes.collection,
    },
    {
      "name": tv,
      "type": QueryTypes.tv,
    },
    {
      "name": companies,
      "type": QueryTypes.companies,
    }
  ]; 
}

class GlobalsFunc {
  
  static void snackBar(context, [message = GlobalsMessage.defaultError, duration = 4]) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: Text(message), 
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: duration),
    ));
  }

  static Future<Response> fetchData(url) {
    return get(url).timeout(Duration(seconds: 5));
  }
}