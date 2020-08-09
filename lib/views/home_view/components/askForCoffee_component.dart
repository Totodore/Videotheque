import 'package:Videotheque/globals.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_redirect/store_redirect.dart';

class AskForCoffeeComponent extends StatelessWidget {
  final Function _onClick;

  AskForCoffeeComponent(this._onClick);
  @override
  Widget build(BuildContext context) => Dismissible(
      key: GlobalKey(),
      child: Card(
        color: GlobalsColor.green,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
          child: Column(children: [
            Text("Si vous aimez Vidéothèque n'hésitez pas à me supporter en m'offrant un café ou en rajoutant un commentaire sur le Play Store. Cela permettra à cette application de rester gratuite et sans publicités ainsi que d'être plus connue.",
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
                FlatButton(
                  onPressed: StoreRedirect.redirect,
                  child: Text("Laisser un commentaire", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  textColor: Colors.white,
                ),
                RaisedButton.icon(
                  icon: Icon(CommunityMaterialIcons.coffee),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.white,
                  label: Text("Faire un don"),
                  elevation: 2,
                  highlightElevation: 3,
                  onPressed: _onClick,
                )
              ],
            )
          ]),
        ),
    ),
  );
}