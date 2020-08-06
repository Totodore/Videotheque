import 'package:Videotheque/components/divider_component.dart';
import 'package:Videotheque/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) => PreferredSize(
    preferredSize: Size.fromHeight(150.2),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 20, left: 10),
              child: Image(
                image: AssetImage("assets/launcher_iconV2.png"),
                width: MediaQuery.of(context).size.width/4,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 10),
              child: Text("Vidéothèque", style: TextStyle(
                  fontWeight: FontWeight.w700, 
                  fontSize: 50,
                  fontFamily: 'Aladin',
                  color: Colors.black,
                  letterSpacing: 1,
                ), 
                textAlign: TextAlign.center,
              ),
            )
          ]
        ),
      ],
    ),
  );
}