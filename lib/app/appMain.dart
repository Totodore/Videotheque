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
    final MainAppRoute args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        backgroundColor: GlobalsColor.lightGreen,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Accueil"),
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            title: Text("Ma Vidéothèque"),
            activeIcon: Icon(Icons.video_library),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text("Mon compte"),
            activeIcon: Icon(Icons.account_circle),
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