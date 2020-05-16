import 'dart:async';

import 'package:flutter/cupertino.dart';

class LibraryController extends ChangeNotifier {
  BuildContext context;
  BuildContext scaffoldContext;

  bool dispStartupAnimation = false;
  LibraryController(this.context) {
  }
}