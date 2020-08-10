import 'package:Videotheque/globals.dart';
import 'package:flutter/material.dart';

class AlertOldAccountComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Dismissible(
    key: UniqueKey(), 
    child: Card(
      color: GlobalsColor.green,
      margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Text("Si vous possédiez un compte sur l'ancienne version de cette application, veuillez vous réinscrire, une fois inscrit vous pourrez récupérer vos données.",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15.5,
            color: Colors.white
          ),
          textAlign: TextAlign.justify,
        ),
      ),
    )
  );
}