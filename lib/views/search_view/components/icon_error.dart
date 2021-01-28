import 'package:flutter/material.dart';
import 'package:Videotheque/Globals.dart';
  
class IconErrorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 100), 
          child: Center(
            child: Icon(Icons.error_outline, 
              size: 100
            )
          )
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(GlobalsMessage.defaultError,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
        )
      ],
    );
  }
}