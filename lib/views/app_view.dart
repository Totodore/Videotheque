import 'package:Videotheque/views/account_view/account_view.dart';
import 'package:Videotheque/views/home_view/home_view.dart';
import 'package:Videotheque/views/library_view/library_view.dart';
import 'package:Videotheque/views/search_view/search_view.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Videotheque/controllers/app_controller.dart';
import 'package:Videotheque/Globals.dart';

class AppView extends StatelessWidget {
  List<Widget> _children;

  AppView() {
    _children = [
      SearchView(),
    ];
  }

  logged(){
    _children = [
      HomeView(),
      LibraryView(),
      _children[0],
      AccountView(),
    ];
  }
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppController>(
      create: (context) => AppController(context),
      child: Consumer<AppController>(
        builder: (context, controller, child) {
          return Scaffold(
            body: _children[controller.bottomNavPositionIndex],
            bottomNavigationBar: BottomNavyBar(
              onItemSelected: (int index) => controller.bottomNavupdateIndex(index),
              backgroundColor: Colors.white,
              showElevation: true,
              iconSize: 25,
              selectedIndex: controller.bottomNavPositionIndex,
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
                    "Mon Compte",
                    textAlign: TextAlign.center,
                  ),
                  activeColor: GlobalsColor.darkGreen,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
