import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10.0),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 20, left: 10),
              child: Image(
                image: AssetImage("assets/icon/launcher_iconV2.png"),
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