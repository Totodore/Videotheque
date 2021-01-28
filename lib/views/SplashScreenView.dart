import 'package:flutter/material.dart';

class SplashScreenView extends StatelessWidget {
  final Function _fn;
  BuildContext _context;
  SplashScreenView(this._fn);

  @override
  Widget build(BuildContext context) {
    _context = context;
    _loading();
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      color: Colors.white,
      child: Center(child: Image(
        image: AssetImage("assets/icon/splash.png"),
        fit: BoxFit.scaleDown,
        height: 160,
      )),
    );
  }

  _loading() async {
    String route = await _fn();
    Navigator.popAndPushNamed(_context, route);
  }
}