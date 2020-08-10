import 'package:Videotheque/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AskMailComponent extends StatelessWidget {
  final Function _sendMail;
  final String _mail;
  AskMailComponent(this._sendMail, this._mail);  
  
  @override
  Widget build(BuildContext context) => Card(
    color: GlobalsColor.green,
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 5),
      child: Column(children: [
        Text("Vous n'avez pas vérifié votre adresse mail : $_mail, pensez à vérifier vos spams.",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15.5,
            color: Colors.white
          ),
          textAlign: TextAlign.justify,
        ),
        ButtonBar(
          alignment: MainAxisAlignment.end,
          children: [
            RaisedButton(
              padding: EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white,
              child: Text("Renvoyer l'email"),
              elevation: 2,
              highlightElevation: 3,
              onPressed: () => _sendMail(context, _mail),
            )
          ],
        )
      ]),
    ),
  );
}