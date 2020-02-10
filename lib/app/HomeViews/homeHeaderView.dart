import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:Videotheque/globals.dart';

import 'package:Videotheque/app/HomeViews/onlineSearchView.dart';
import 'package:Videotheque/app/HomeViews/homeBodyView.dart';

class CustomPopupMenu {
  CustomPopupMenu({this.title, this.icon});
 
  String title;
  IconData icon;
}

class HomeApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeAppState();
  }
}

class HomeAppState extends State<HomeApp> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( //Default app BAR
        leading: Icon(Icons.subscriptions,
          color: GlobalsColor.darkGreen,
          size: 38,
        ),
        title: Text("Vidéothèque",
          style: TextStyle(
            fontFamily: "Aladin",
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: GlobalsColor.darkGreen,
          ),
        ),
        backgroundColor: GlobalsColor.lightGreen,
        elevation: 2,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search,
              color: GlobalsColor.darkGreen,
              size: 35,
            ),
            onPressed: () => setState(() => Navigator.pushNamed(context, "/search")),
          )
        ],
      ),
      body: HomeBodyView(),
    );
  }
}