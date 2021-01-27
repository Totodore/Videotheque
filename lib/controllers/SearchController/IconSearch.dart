
import 'package:flutter/material.dart';

class IconSearchController extends ChangeNotifier {
  final Duration animationDelay = Duration(milliseconds: 500); 

  IconSearchController() {
    updateAnimation(true);
  }

  bool dispAnimation = false;

  void updateAnimation(bool display) {
    dispAnimation = !display;

    Future.delayed(const Duration(milliseconds: 10), () {dispAnimation = display; notifyListeners();});
    notifyListeners();
  }

}