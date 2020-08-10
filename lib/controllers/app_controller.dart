import 'package:flutter/material.dart';

class AppController extends ChangeNotifier {

  int bottomNavPositionIndex = 0;
  int oldBottomNavPositionIndex = 0;
  Animation<Offset> slidingAnimation;
  Animation<double> fadingAnimation;

  double width;
  BuildContext context;

  AppController(BuildContext context);

  void bottomNavupdateIndex(int index) {
    oldBottomNavPositionIndex = bottomNavPositionIndex;
    bottomNavPositionIndex = index;
    notifyListeners();
  }

}