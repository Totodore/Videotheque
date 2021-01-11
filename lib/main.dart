import 'package:Videotheque/services/FireauthQueries.dart';
import 'package:Videotheque/services/FireconfigQueries.dart';
import 'package:Videotheque/services/FirestoreQueries.dart';
import 'package:Videotheque/services/TmdbQueries.dart';
import 'package:Videotheque/utils/Singletons.dart';
import 'package:Videotheque/views/SplashScreenView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:Videotheque/views/app_view.dart';
import 'package:Videotheque/views/movie_view/movie_view.dart';
import 'package:Videotheque/views/person_view/person_view.dart';
import 'package:Videotheque/views/search_view/search_view.dart';
import 'package:Videotheque/views/collection_view/collection_view.dart';
import 'package:Videotheque/views/tv_view/tv_view.dart';
import 'package:Videotheque/views/authView/AuthView.dart';
import 'package:flutter/services.dart';
import 'Globals.dart';

void main() async {
  registerSingletons();
  await configureApp();

  AppView mainView;
  runApp(MaterialApp(
    title: 'Vidéothèque',
    color: Color(0xFF008577),
    initialRoute: "/splash",
    routes: {
      "/splash": (context) => SplashScreenView(() async {
        if (await Singletons.instance<FireauthQueries>().needSignIn)
          return "/auth";
        else {
          mainView.logged();
          return "/";
        }
      }),
      "/": (context) => mainView ??= AppView(),
      "/auth": (context) => AuthView(mainView),
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

registerSingletons() {
  print("Registering singletons...");
  Singletons.registerSingleton(new FirestoreQueries());
  Singletons.registerSingleton(new FireauthQueries());
  Singletons.registerSingleton(new FireconfigQueries());
  Singletons.registerSingleton(new TMDBQueries());
}

configureApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
}