import 'package:Videotheque/app/HomeViews/onlineSearchView.dart';
import 'package:flutter/material.dart';

import 'Connexion/mainConnexion.dart';
import 'app/appMain.dart';
import 'app/ElementsViews/movieView.dart';
import 'app/ElementsViews/personView.dart';
import 'app/ElementsViews/tvView.dart';
import 'app/ElementsViews/collectionView.dart';
import 'app/ElementsViews/companyView.dart';
import 'webApp.dart';

void main() {
  runApp(MaterialApp(
    title: 'Vidéothèque',
    color: Color(0xFF008577),
    initialRoute: "/",
    routes: {
      "/": (context) => App(),
      "/webapp": (context) => WebApp(),
      "/search": (context) => OnlineSearchView(),
      "/connexion/": (context) => Connexion(),
      "/element/movie/": (context) => MovieView(),
      "/element/person/": (context) => PersonView(),
      "/element/tv/": (context) => TvView(),
      "/element/collection/": (context) => CollectionView(),
      "/element/company/": (context) => CompanyView(), 
    },
  ));
}
