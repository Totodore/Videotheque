import 'package:Videotheque/globals.dart';
import 'package:flutter/material.dart';

class TransferDBDialogComponent extends StatelessWidget {

  final Function _onClose;
  final Function _onConfirm;
  final TextEditingController _textController;
  final BuildContext _context;

  TransferDBDialogComponent(this._onClose, this._onConfirm, this._textController, this._context);
  
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text("Récupérer mes données"),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text("Si vous possédiez un compte sur l'ancienne application, vous pouvez récupérer vos données en entrant votre mail : ",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            textAlign: TextAlign.justify,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: TextField(
            controller: _textController,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: GlobalsColor.darkGreen),
              labelText: "Mail de votre ancien compte",
              contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(3)),
                borderSide: BorderSide(
                  color: GlobalsColor.darkGreen,
                  width: 2,
                  style: BorderStyle.solid
                )
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(3)),
                borderSide: BorderSide(
                  color: GlobalsColor.darkGreen,
                  width: 2,
                  style: BorderStyle.solid
                )
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: ButtonBar(
              alignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                  textColor: GlobalsColor.darkGreen,
                  splashColor: GlobalsColor.darkGreen.withAlpha(100),
                  onPressed: () => _onClose(_context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("Annuler"),
                  ),
                ),
                RaisedButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("Transférer"),
                  ),
                  color: GlobalsColor.darkGreen,
                  highlightElevation: 3,
                  onPressed: () => _onConfirm(_context)
                ),
              ],
            ),
        )
      ],
      
    );
  }
}