import 'dart:async';

import 'package:Videotheque/controllers/library_controller/library_body_controller.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/views/collection_view/collection_view.dart';
import 'package:Videotheque/views/library_view/sortby_view.dart';
import 'package:Videotheque/views/movie_view/movie_view.dart';
import 'package:Videotheque/views/person_view/person_view.dart';
import 'package:Videotheque/views/tv_view/tv_view.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:uuid/uuid.dart';

class LibraryStickyController extends ChangeNotifier {
  
  Offset startRippleAnimation;
  Animation rippleAnimation;
  List _libraryData;
  List _displayLibraryData;
  Map<String, dynamic> _tags;

  final GlobalKey stickyHeaderKey = GlobalKey();
  final AnimationController rippleAnimationController;
  final LibraryBodyController parentController;
  final QueryTypes type;
  final StickyHeaderController _libraryHeaderController = StickyHeaderController();
  final BuildContext context;
  final FocusNode focusSearchBar = FocusNode();
  final double STICKY_HEADER_POS = 745.5;

  bool _displaySearchBar = false;
  SortOptions _sortOption = SortOptions.Popularity;
  Timer delayOkSearch;

  LibraryStickyController(this.context, this.type, this.parentController, this.rippleAnimationController) {
    _libraryData = parentController.libraryData;
    _displayLibraryData = _libraryData;
    
    rippleAnimation = Tween(begin: 0.0, end: 1.0).animate(rippleAnimationController);
    rippleAnimationController.addStatusListener(onRippleAnimation);
  }

   void onSortButtonClick() {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => SortByView(this, _sortOption),
      animationType: DialogTransitionType.slideFromBottom,
      duration: const Duration(milliseconds: 200),
    );
  }

  
  void onSearchButtonClick(TapUpDetails details) {
    startRippleAnimation = details.globalPosition;
    _tags = parentController.tags;

    Scrollable.ensureVisible(stickyHeaderKey.currentContext, duration: Duration(milliseconds: 250));
    rippleAnimationController.forward();
  }

  void onCloseSearchClick() {
    _displaySearchBar = false;
    notifyListeners();
    resetView();
    rippleAnimationController.reverse();
  }

  void onRippleAnimation(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _displaySearchBar = true;
      focusSearchBar.requestFocus();
      notifyListeners();
    }
  }

  
  void sortElements(SortOptions sortOptions) {
    _libraryData.sort((a, b) {
      switch (sortOptions) {
        case SortOptions.Popularity:
          return b["popularity"].compareTo(a["popularity"]);
        case SortOptions.Alpha1:
          return a["title"].compareTo(b["title"]);
        case SortOptions.Alpha2:
          return b["title"].compareTo(a["title"]);
        case SortOptions.Date:
          return b["creation_date"].compareTo(a["creation_date"]);
        default:
          return 0;
      }
    });
    notifyListeners();
  }

  void onSearchLibrary(String query) {
    if (query == null || query.length == 0)
      resetView();
    if (delayOkSearch != null) {
      delayOkSearch.cancel();
    }
    delayOkSearch = Timer(const Duration(milliseconds: 100), () {delayOkSearch = null; searchQueryLibrary(query);});
  }

  void resetView() {
    _displayLibraryData = _libraryData;
    notifyListeners();
  }

  void searchQueryLibrary(String query) {
    _displayLibraryData = _libraryData.where((el) {
        if (el["title"].toString().toUpperCase().contains(query.toUpperCase()))
          return true;
        for (var tagKey in List.from(el["base_tags"])..addAll(el["added_tags"])) {
          if (_tags[tagKey.toString()].toString().toUpperCase().contains(query.toUpperCase())) return true;
        }
        return false;
    }).toList();
    notifyListeners();
  }

  
  closeDialogSort(SortOptions newOption) {
    Navigator.of(context).pop();
    if (newOption != _sortOption) {
      _sortOption = newOption;
      sortElements(_sortOption);
    }
  }

  
  onElementTapped(int index, String heroTag) async {
    QueryTypes type = EnumToString.fromString(QueryTypes.values, _displayLibraryData[index]["type"]);
    GlobalsArgs.actualRoute = "/element/" + GlobalsMessage.chipData[QueryTypes.values.indexOf(type)]["route"];
    GlobalsArgs.transfertArg = [_displayLibraryData[index], heroTag];
    GlobalsArgs.isFromLibrary = true;
    switch (GlobalsArgs.actualRoute) {
      case "/element/movie":
        Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => MovieView()));
        break;
      case "/element/person":
        Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => PersonView()));
        break;
      case "/element/tv":
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TvView()));
        break;
      case "/element/collection":
        Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => CollectionView()));
        break;
      default:
    }
  }

  int get libraryLength => _displayLibraryData.length;

  String get heroTag => Uuid().v1();

  String getNameElement(int index) {
    return _displayLibraryData[index]["title"];
  }

  String getImageElement(int index) {
    return _displayLibraryData[index]["image_url"];
  }

  QueryTypes getElementType(int index) => 
    EnumToString.fromString(QueryTypes.values, _displayLibraryData[index]["type"]);

  ImageTypes getImageType(int index) {
    QueryTypes type = EnumToString.fromString(QueryTypes.values, _displayLibraryData[index]["type"]);
    return GlobalsMessage.chipData[QueryTypes.values.indexOf(type)]["image_type"];
  }
  
  StickyHeaderController get libraryHeaderController =>_libraryHeaderController;

  bool get dispSearchBar => _displaySearchBar;


}