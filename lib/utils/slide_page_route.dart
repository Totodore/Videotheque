import 'package:flutter/material.dart';
class SlideLeftRoute extends PageRouteBuilder {
  final Widget page;
  
  SlideLeftRoute({this.page}) : super(
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> animation2,) => page,
    transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> animation2, Widget child,) => SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    ),
  );
}