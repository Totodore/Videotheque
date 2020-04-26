import 'package:flutter/material.dart';

class BottomNavigationController extends ChangeNotifier {

  int positionIndex = 0;

  void updateIndex(int index) {
    this.positionIndex = index;
    notifyListeners();
  }

}