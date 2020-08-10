import 'package:flutter/material.dart';

class NoContentComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
    child: Column(children: <Widget>[
      Text("Commencez par rechercher des films, artistes, séries pour les ajouter à votre Vidéothèque !", style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        height: 1.4
      ), textAlign: TextAlign.center,)
    ]),
  );
}