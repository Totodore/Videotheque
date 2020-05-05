import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Videotheque/controllers/bottom_navigation/bottom_navigation_controller.dart';
import 'package:Videotheque/globals.dart';

class BottomNavigationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BottomNavigationController>(
      create: (context) => BottomNavigationController(),
      child: Consumer<BottomNavigationController>(
        builder: (context, controller, child) {
          return BottomNavyBar(
            onItemSelected: controller.updateIndex,
            backgroundColor: Colors.white,
            showElevation: true,
            iconSize: 25,
            selectedIndex: controller.positionIndex,
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
          );
        },
      ),
    );
  }
}
