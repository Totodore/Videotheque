import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

import 'package:Videotheque/app/account.dart';
import 'package:Videotheque/app/HomeViews/homeHeaderView.dart';
import 'package:Videotheque/app/librarie.dart';
import 'package:Videotheque/globals.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> {

  List<Widget> _children = [
    HomeApp(),
    Library(),
    Account(),
  ];
  int _currentIndex = 0;
  
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
            activeColor: Colors.green,
          ),
          BottomNavyBarItem( 
            icon: Icon(Icons.video_library),
            title: Text("Vidéothèque"),
            activeColor: Colors.green,
          ),
          BottomNavyBarItem( 
            icon: Icon(Icons.account_circle),
            title: Text("Mon compte"),
            activeColor: Colors.green,
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