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
  final AnimationController rippleAnimationController;
  final LibraryBodyController parentController;
  final QueryTypes type;
  final StickyHeaderController _libraryHeaderController = StickyHeaderController();
  final ScrollController _sliverScrollController = ScrollController(keepScrollOffset: true);
  final BuildContext context;

  bool _displaySearchBar = false;
  SortOptions _sortOption = SortOptions.Popularity;


  LibraryStickyController(this.context, this.type, this.parentController, this.rippleAnimationController) {
    _libraryData = parentController.libraryData;
    
    rippleAnimation = Tween(begin: 0.0, end: 1.0).animate(rippleAnimationController);
    rippleAnimationController.addStatusListener(onRippleAnimation);
  }

   void onSortButtonClick() {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => SortByView(this, _sortOption),
      animationType: DialogTransitionType.slideFromBottom,
      duration: const Duration(milliseconds: 400),
    );
  }

  
  void onSearchButtonClick(TapUpDetails details) {
    //TODO: FIX SCROLLING BUG
    print(_libraryHeaderController.stickyHeaderScrollOffset);
    _sliverScrollController.animateTo(
        _libraryHeaderController.stickyHeaderScrollOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease);
    startRippleAnimation = details.globalPosition;
    rippleAnimationController.forward();
  }

  void onCloseSearchClick() {
    _displaySearchBar = false;
    notifyListeners();
    rippleAnimationController.reverse();
  }

  void onRippleAnimation(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _displaySearchBar = true;
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
          return a["creation_date"].compareTo(b["creation_date"]);
        case SortOptions.Fav:
          return a["fav"] ? 1 : b["fav"] ? -1 : 0;
        case SortOptions.Seen:
          return a["seen"] ? 1 : b["seen"] ? -1 : 0;
        case SortOptions.ToSee:
          return a["to_see"] ? 1 : b["to_see"] ? -1 : 0;
        default:
          return 0;
      }
    });
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
    QueryTypes type = EnumToString.fromString(QueryTypes.values, _libraryData[index]["type"]);
    GlobalsArgs.actualRoute = "/element/" + GlobalsMessage.chipData[QueryTypes.values.indexOf(type)]["route"];
    GlobalsArgs.transfertArg = [_libraryData[index], heroTag];
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

  int get libraryLength => _libraryData.length;

  String get heroTag => Uuid().v1();

  String getNameElement(int index) {
    return _libraryData[index]["title"];
  }

  String getImageElement(int index) {
    return _libraryData[index]["image_url"];
  }

  QueryTypes getElementType(int index) => 
    EnumToString.fromString(QueryTypes.values, _libraryData[index]["type"]);

  ImageTypes getImageType(int index) {
    QueryTypes type = EnumToString.fromString(QueryTypes.values, _libraryData[index]["type"]);
    return GlobalsMessage.chipData[QueryTypes.values.indexOf(type)]["image_type"];
  }
  
  StickyHeaderController get libraryHeaderController =>_libraryHeaderController;

  bool get dispSearchBar => _displaySearchBar;


}