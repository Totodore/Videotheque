import 'package:flutter/material.dart';

class AppController extends ChangeNotifier {

  int bottomNavPositionIndex = 1;
  int oldBottomNavPositionIndex = 1;
  Animation<Offset> slidingAnimation;
  Animation<double> fadingAnimation;

  double width;
  BuildContext context;

  AppController(BuildContext context) {
  }

  void bottomNavupdateIndex(int index) {
    oldBottomNavPositionIndex = bottomNavPositionIndex;
    bottomNavPositionIndex = index;
    notifyListeners();
  }

}