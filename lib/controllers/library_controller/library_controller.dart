import 'package:Videotheque/Globals.dart';
import 'package:flutter/cupertino.dart';

class LibraryController extends ChangeNotifier {
  final tabLength = QueryTypes.values.length;
  QueryTypes selectedSort = QueryTypes.all;
  int tabIndex = 0;


  Map<QueryTypes, States> loadedViews = Map.fromIterables(QueryTypes.values, List.generate(QueryTypes.values.length, (int index) => States.Nothing)); //List which represent each view if it has been loaded
  //List which represent offset of result per view
  Map<QueryTypes, List> dataLoadedView = Map.fromIterables(QueryTypes.values, List.generate(QueryTypes.values.length, (int index) => null)); 
 
  BuildContext context;
  BuildContext scaffoldContext;
  bool isInnerBoxScrolled = false;

  bool dispStartupAnimation = false;
  LibraryController(this.context);

  updateIsInnerBoxScrolled(box) {
    if (box != isInnerBoxScrolled) {
      isInnerBoxScrolled = box;
    }
  }

  void updateTabIndex(int index) {
    selectedSort = QueryTypes.values[index];
    tabIndex = index;
    notifyListeners();
  }

  bool isChipSelected(int index) => GlobalsMessage.chipData[index]["type"] == selectedSort; 

}