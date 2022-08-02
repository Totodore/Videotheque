import 'package:Videotheque/Globals.dart';
import 'package:flutter/material.dart';

class IconNothingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 75, bottom: 25), 
          child: Center(
            child: Icon(Icons.not_interested, 
              size: 100
            )
          )
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(GlobalsMessage.noResults,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
        )
      ],
    );
  }
}
