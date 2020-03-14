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
import 'globals.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
    theme: ThemeData.light().copyWith(
      accentColor: GlobalsColor.darkGreenDisabled,
      toggleButtonsTheme: ToggleButtonsThemeData(
        borderColor: Colors.grey,
        borderWidth: 1,
      ),
      chipTheme: ThemeData.light().chipTheme.copyWith(
        secondarySelectedColor: GlobalsColor.darkGreenDisabled,
        disabledColor: GlobalsColor.fadedGreen,
        backgroundColor: Colors.transparent, 
        selectedColor: GlobalsColor.darkGreenDisabled,
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 14),  
        labelStyle: TextStyle(), 
        elevation: 0,
        pressElevation: 1,
        labelPadding: EdgeInsets.only(left: 3.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(width: 0.7, style: BorderStyle.solid, color: Colors.grey.withAlpha(100))
        ),

      )
    ),
  ));
}
