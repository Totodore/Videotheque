import 'dart:async';

import 'package:Videotheque/globals.dart';
import 'package:flutter/cupertino.dart';

class LibraryController extends ChangeNotifier {
  final tabLength = QueryTypes.values.length;
  QueryTypes selectedSort = QueryTypes.all;


  BuildContext context;
  BuildContext scaffoldContext;
  bool isInnerBoxScrolled = false;

  bool dispStartupAnimation = false;
  LibraryController(this.context) {
  }

  set updateIsInnerBoxScrolled(box) => isInnerBoxScrolled = box;

  void updateTabIndex(int index) {
  }

  bool isChipSelected(int index) => GlobalsMessage.chipData[index]["type"] == selectedSort; 

}