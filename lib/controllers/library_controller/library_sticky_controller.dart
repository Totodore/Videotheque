import 'package:flutter/cupertino.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class LibraryStickyController extends ChangeNotifier {
  
  Offset startRippleAnimation;
  Animation rippleAnimation;
  final AnimationController rippleAnimationController;
  
  final StickyHeaderController _libraryHeaderController = StickyHeaderController();
  final ScrollController _sliverScrollController = ScrollController(keepScrollOffset: true);
  bool _displaySearchBar = false;

  LibraryStickyController(, this.rippleAnimationController) {
    
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

}