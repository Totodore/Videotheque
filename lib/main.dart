import 'package:Videotheque/api/fireauthQueries.dart';
import 'package:Videotheque/api/firestoreQueries.dart';
import 'package:Videotheque/views/SplashScreenView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:Videotheque/views/app_view.dart';
import 'package:Videotheque/views/movie_view/movie_view.dart';
import 'package:Videotheque/views/person_view/person_view.dart';
import 'package:Videotheque/views/search_view/search_view.dart';
import 'package:Videotheque/views/collection_view/collection_view.dart';
import 'package:Videotheque/views/tv_view/tv_view.dart';
import 'package:Videotheque/views/auth_view.dart/auth_view.dart';
import 'package:flutter/services.dart';
import 'webApp.dart';
import 'globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MaterialApp(
    title: 'Vidéothèque',
    color: Color(0xFF008577),
    initialRoute: "/splash",
    routes: {
      "/": (context) => AppView(),
      "/splash": (context) => SplashScreenView(() async {
        await Firebase.initializeApp();
        return await FireauthQueries.needSignIn ? "/auth" : "/";
      }),
      "/auth": (context) => AuthView(),
      "/webapp/": (context) => WebApp(),
      "/search/": (context) => SearchView(),
      "/element/movie/": (context) => MovieView(),
      "/element/person/": (context) => PersonView(),
      "/element/tv/": (context) => TvView(),
      "/element/collection/": (context) => CollectionView(),
    },
    theme: ThemeData.light().copyWith(
      accentColor: GlobalsColor.darkGreenDisabled,
      primaryColor: Colors.white,
      brightness: Brightness.light,
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