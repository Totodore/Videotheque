import 'package:Videotheque/Globals.dart';
import 'package:flutter/cupertino.dart';

class SortByController extends ChangeNotifier {

  SortByController(this._sortOptionsValue);
  
  SortOptions _sortOptionsValue;
  SortOptions get sortOption => _sortOptionsValue;

  onSortOptionUpdate(SortOptions sortOptions) {
     _sortOptionsValue = sortOptions;
     notifyListeners();
  } 
}