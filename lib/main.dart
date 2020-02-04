import 'package:flutter/material.dart';

import 'Connexion/mainConnexion.dart';
import 'app/appMain.dart';
import 'app/ElementsViews/movieView.dart';
import 'webApp.dart';

void main() {
  runApp(MaterialApp(
    title: 'Vidéothèque',
    color: Color(0xFF008577),
    initialRoute: "/",
    routes: {
      "/": (context) => App(),
      "/webapp": (context) => WebApp(),
      "/connexion/": (context) => Connexion(),
      "/element/movie/": (context) => MovieView()
    },
  ));
}
