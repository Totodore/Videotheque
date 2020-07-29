import 'package:flutter/material.dart';

class NoDataComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: MediaQuery.of(context).size.height/5),
      child: Center(
        child: Column(children: <Widget>[
          Icon(Icons.error_outline, size: 95),
          Padding(padding: EdgeInsets.only(bottom: 15)),
          Text("Vous n'avez encore rien ajouté dans cette catégorie", 
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)
          )
        ]),
      ),
    );
  }
}