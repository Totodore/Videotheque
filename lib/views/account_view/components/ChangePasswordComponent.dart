import 'package:Videotheque/globals.dart';
import 'package:flutter/material.dart';

class ChangePasswordComponent extends StatelessWidget {

  final Function _onConfirm;
  final Function _onClose;
  final TextEditingController _textController;
  final TextEditingController _textController2;
  final BuildContext _context;

  ChangePasswordComponent(this._onConfirm, this._onClose, this._textController, this._textController2, this._context);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text("Changer mon mot de passe"),
      children: [
        Column(children: [
          TextField(
            controller: _textController,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: GlobalsColor.darkGreen),
              labelText: "Ancien mot de passe",
              contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(3)),
                borderSide: BorderSide(
                  color: GlobalsColor.darkGreen,
                  width: 2,
                  style: BorderStyle.solid
                )
              ),
            ),
          ),
          TextField(
            controller: _textController2,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: GlobalsColor.darkGreen),
              labelText: "Nouveau mot de passe",
              contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(3)),
                borderSide: BorderSide(
                  color: GlobalsColor.darkGreen,
                  width: 2,
                  style: BorderStyle.solid
                )
              ),
            ),
          ),
          ButtonBar(
              alignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: RaisedButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("Confirmer"),
                    ),
                    color: GlobalsColor.darkGreen,
                    highlightElevation: 3,
                    onPressed: () => _onConfirm(_context)
                  )
                ),
                FlatButton(
                  textColor: GlobalsColor.darkGreen,
                  splashColor: GlobalsColor.darkGreen.withAlpha(100),
                  onPressed: () => _onClose(_context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("Annuler"),
                  ),
                )
              ],
            )
        ])
      ],
      
    );    
  }
}