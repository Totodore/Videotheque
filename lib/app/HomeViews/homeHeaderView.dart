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
      body: HomeBodyView(),
    );
  }
}