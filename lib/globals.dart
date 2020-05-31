import 'package:Videotheque/views/collection_view/collection_view.dart';
import 'package:Videotheque/views/movie_view/movie_view.dart';
import 'package:Videotheque/views/person_view/person_view.dart';
import 'package:Videotheque/views/tv_view/tv_view.dart';
import 'package:flutter/material.dart';

class GlobalsColor {
  static final darkGreen = Color(0xFF00574B);
  static final darkGreenDisabled = Color(0xFF00574B).withAlpha(100);
  static final plainDarkGreenDisabled = Color(0xFF99bcb7);
  static final green = Color(0xFF295f5f);
  static final splashGreen = Color(0xFF00574B).withAlpha(100);

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
  static const String ytApiKey = "AIzaSyAJgzmg3zxU6nhQOOlb6EZ2NN4i5-yJsYo";
  static const String lang = "fr-FR";
  
  static const String backdropSize = "https://image.tmdb.org/t/p/w780/";
  static const String thumbBackdropSize = "https://image.tmdb.org/t/p/w300/"; 
  static const String posterSize = "https://image.tmdb.org/t/p/w780/";
  static const String thumbPosterSize = "https://image.tmdb.org/t/p/w92/";
  static const String thumbProfileSize = "https://image.tmdb.org/t/p/w45/";
  static const String profileSize = "https://image.tmdb.org/t/p/h632/";

  static double initSortBarPos = 59;  //Default value
  static double endSortBarPos = 24.0;
  static double deltaSortBarPos = initSortBarPos - endSortBarPos;

}


class GlobalsMessage {
  static const String errorPassConnect = "Le mot de passe rentré n'existe pas";
  static const String errorUserConnect = "Le nom d'utilisateur rentré n'existe pas";
  static const String errorConnect = "Erreur lors de la tentative de connexion";
  static const String errorMail = "Erreur lors de la récupération du mail, veuillez recommencer dès que possible";
  static const String askMail = "Suite à une mise à jour il est maintenant requis d'entrer une adresse email valide pour ouvrir ou utiliser un compte, veuillez renseigner la votre ci-dessous. Elle vous permettra de récupérer votre mot de passe en cas de perte ou de changement majeurs de l'application.";
  static const String defaultError = "Une erreur est apparue lors de la récupération de vos données";
  static const String noResults = "Ouuups, aucun résultat n'a été trouvé pour votre recherche";
  static const String defaultSearchMessage = "Recherchez, Ajoutez, Triez, Le tour est joué ! ";

  static const String general = "Recherche générale";
  static const String movie = "Films";
  static const String person = "Personnes";
  static const String collection = "Collections";
  static const String tv = "Séries TV";
  static const String companies = "Companies"; 

  static List<Map<dynamic, dynamic>> chipData = [
    {
      "name": general,
      "type": QueryTypes.all,
      "color": Color(0XFF636363),
      "selected_color": Color(0XFF636363).withAlpha(50),
      "splash_color": Color(0XFF636363).withAlpha(100),
      "icon": Icons.apps,
      "keyword": "Ma Vidéothèque",
      "library_appBar": "Ma Vidéothèque"
    },
    {
      "name": movie,
      "type": QueryTypes.movie,
      "route": "movie",
      "color": Color(0xFF00574B),
      "selected_color": Color(0xFF00574B).withAlpha(50),
      "splash_color": Color(0xFF00574B).withAlpha(100),
      "icon": Icons.movie,
      "db_route": "movies",
      "image_type": ImageTypes.Poster,
      "keyword": "Films",
      "library_appBar": "Mes Films"
    },
    {
      "name": tv,
      "type": QueryTypes.tv,
      "route": "tv",
      "color": Color(0xFF7c0091),
      "selected_color": Color(0xFF7c0091).withAlpha(50),
      "splash_color": Color(0xFF7c0091).withAlpha(100),
      "icon": Icons.tv,
      "db_route": "series",
      "image_type": ImageTypes.Poster,
      "keyword": "Séries TV",
      "library_appBar": "Mes Séries TV"
    },
    {
      "name": person,
      "type": QueryTypes.person,
      "route": "person",
      "color": Color(0xFF9c0000),
      "selected_color": Color(0xFF9c0000).withAlpha(50),
      "splash_color": Color(0xFF9c0000).withAlpha(100),
      "icon": Icons.person,
      "db_route": "people",
      "image_type": ImageTypes.Profile,
      "keyword": "Personnes",
      "library_appBar": "Personnes"
    },
    {
      "name": collection,
      "type": QueryTypes.collection,
      "route": "collection",
      "color": Color(0xFF2f26c9),
      "selected_color": Color(0xFF2f26c9).withAlpha(50),
      "splash_color": Color(0xFF2f26c9).withAlpha(100),
      "icon": Icons.subscriptions,
      "db_route": "collections",
      "image_type": ImageTypes.Poster,
      "keyword": "Collections",
      "library_appBar": "Mes Collections"
    },
    // {
    //   "name": companies,
    //   "type": QueryTypes.companies,
    //   "route": "company",
    //   "color": Color(0XFF2f26c9),
    //   "selected_color": Color(0XFF2f26c9).withAlpha(50),
    //   "splash_color": Color(0XFF2f26c9).withAlpha(100),
    //   "icon": Icons.business,
    //   "db_route": "companies",
    // }
  ]; 
}

class GlobalsFunc {
  
  static void snackBar(context, [message = GlobalsMessage.defaultError, duration = 4]) {
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: Text(message), 
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: duration),
    ));
  }
}

class GlobalsArgs {
  static dynamic transfertArg;
  static String actualRoute;
  static bool isFromLibrary;
}


enum States {
  Empty,
  Error,
  Loading,
  Added,
  Nothing
}

enum ElementsTypes {
  MainData,
  GenreTags,
  InfoTags,
  MadeByCarrousel,
  CastingCarrousel,
  CrewCarrousel,
  SimilarCarrousel,
  KnownForMovieCarrousel,
  KnownForTvCarrousel,
  SeasonsCarrousel,
  EpisodesCarrousel,
  GuestsCarrousel,
  MoviesCarrousel,
  ToSeeCarrousel,
  SeenCarrousel,
  FavCarrousel,
  YoutubeTrailer,
}

enum ImageTypes {
  Backdrop,
  Profile,
  Poster,
  Still
}

enum Options {
  Seen,
  ToSee,
  Fav
}

enum QueryTypes {
  all,
  movie,
  tv,
  person,
  collection,
  // companies
}