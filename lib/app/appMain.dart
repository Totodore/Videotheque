import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

import 'package:Videotheque/app/baseViews/searchView.dart';
import 'package:Videotheque/app/baseViews/homeView.dart';
import 'package:Videotheque/app/baseViews/accountView.dart';
import 'package:Videotheque/app/baseViews/librarieView.dart';
import 'package:Videotheque/globals.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> {

  List<Widget> _children = [
    HomeView(),
    LibraryView(),
    SearchView(),
    AccountView(),
  ];
  int _currentIndex = 2;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavyBar(
        selectedIndex:  _currentIndex,
        backgroundColor: Colors.white,
        showElevation: true,
        onItemSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        iconSize: 25,
        items: [
          BottomNavyBarItem( 
            icon: Icon(Icons.home),
            title: Text(
              "Accueil",
              textAlign: TextAlign.center,
            ),
            activeColor: GlobalsColor.darkGreen,
          ),
          BottomNavyBarItem( 
            icon: Icon(Icons.video_library),
            title: Text(
              "Vidéothèque",
              textAlign: TextAlign.center,
            ),
            activeColor: GlobalsColor.darkGreen,
          ),
          BottomNavyBarItem( 
            icon: Icon(Icons.search),
            title: Text(
              "Recherche",
              textAlign: TextAlign.center,
            ),
            activeColor: GlobalsColor.darkGreen,
          ),
          BottomNavyBarItem( 
            icon: Icon(Icons.account_circle),
            title: Text(
              "Mon compte",
              textAlign: TextAlign.center,
            ),
            activeColor: GlobalsColor.darkGreen,
          )
        ],
      ),
      body: _children[_currentIndex],
    );
  }
}


class MainAppRoute {
  static const RouteName = "/app";
  
  final String user;
  final String pass;

  MainAppRoute(this.user, this.pass);
}