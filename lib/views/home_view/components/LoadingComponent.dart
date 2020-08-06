import 'package:Videotheque/globals.dart';
import 'package:flutter/material.dart';

class LoadingComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    height: 400,
    color: Colors.white,
    width: double.infinity,
    child: Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(GlobalsColor.darkGreen),
        backgroundColor: Colors.white,
      ),
    ),
  );
}