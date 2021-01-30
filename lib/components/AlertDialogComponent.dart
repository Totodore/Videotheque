import 'package:flutter/material.dart';

class AlertDialogComponent extends StatelessWidget {
  final String title;
  final Function onConfirmed;
  final Function onAbort;
  final Color mainColor;
  final String content;
  String buttonAbort = "Annuler";
  String buttonConfirm = "Confirmer";

  AlertDialogComponent({this.title, this.onConfirmed, this.onAbort, this.mainColor, this.content, this.buttonAbort, this.buttonConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: title != null ? Text(title) : Container(),
        contentPadding: title == null ? EdgeInsets.symmetric(vertical: 5, horizontal: 25) : EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        content: content != null ? Text(content) : Container(),
        contentTextStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 16.5), 
        actions: <Widget>[
          FlatButton(
            onPressed: onAbort, 
            child: Text(this.buttonAbort ?? "Annuler", style: TextStyle(color: mainColor)),
            splashColor: mainColor.withAlpha(50),
          ),
          RaisedButton(
            onPressed: onConfirmed,
            child: Text(this.buttonConfirm ?? "Confirmer"),
            elevation: 2,
            highlightElevation: 3,
            color: mainColor,
          )
        ],
      );
  }
}