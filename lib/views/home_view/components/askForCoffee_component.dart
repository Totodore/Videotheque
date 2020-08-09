import 'package:Videotheque/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        child: InkWell(
          onTap: _onClick,
          splashColor: Colors.black.withOpacity(0.15),
          highlightColor: Colors.black.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
            child: Column(children: [
              Text("Si vous aimez Vidéothèque n'hésitez pas à me supporter en m'offrant un café. Cela permettra à cette application de rester gratuite et sans publicités.",
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
                    child: Text("Faire un don"),
                    elevation: 2,
                    highlightElevation: 3,
                    onPressed: _onClick,
                  )
                ],
              )
            ]),
          ),
        ),
    ),
  );
}