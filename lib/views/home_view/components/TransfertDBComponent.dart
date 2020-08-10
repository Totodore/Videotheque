import 'package:Videotheque/globals.dart';
import 'package:flutter/material.dart';

class TransfertDBComponent extends StatelessWidget {
  final Function onConfirm;
  final Function onAbort;
  final Function onDismissed;

  TransfertDBComponent(this.onConfirm, this.onAbort, this.onDismissed);
  
  @override
  Widget build(BuildContext context) => Dismissible(
      onResize: onDismissed,
      key: GlobalKey(),
      child: Card(
      color: Colors.white,
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 25, top: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 5),
        child: Column(children: [
          Text("L'application vient de changer de version, mais pas de soucis, il vous suffit de cliquer sur le bouton ci-dessous pour récupérer vos données précédentes, vous pouvez aussi à tout moment effectuer cette action depuis les paramètres",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15.5,
            ),
            textAlign: TextAlign.justify,
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                onPressed: onAbort, 
                child: Text("Non merci", style: TextStyle(color: GlobalsColor.darkGreen)),
                splashColor: GlobalsColor.darkGreen.withAlpha(50),
              ),
              RaisedButton(
                onPressed: onConfirm, 
                child: Text("Récupérer mes données"),
                color: GlobalsColor.darkGreen,
                highlightElevation: 3,
              )
            ],
          )
        ]),
      ),
    ),
  );
}