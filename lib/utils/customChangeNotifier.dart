import 'package:flutter/cupertino.dart';

abstract class CustomChangeNotifier extends ChangeNotifier {
  bool _mounted = true;
  bool get mounted => _mounted;

  @override 
  void dispose() {
    super.dispose();
    _mounted = false;
  }
}