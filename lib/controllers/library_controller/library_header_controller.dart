import 'dart:async';

import 'package:flutter/cupertino.dart';

class LibraryHeaderController extends ChangeNotifier {
  bool dispStartupAnimation = false;

  LibraryHeaderController() {
    Timer(Duration(milliseconds: 50), () {
      dispStartupAnimation = true;
      notifyListeners();    
    });
  }
} 