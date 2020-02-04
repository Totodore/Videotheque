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

  bool _dispSearch = false;
  OnlineSearchView searchView;
  //Base title AppBar
  final Text _baseTitleAppBar = Text("Vidéothèque",
    style: TextStyle(
      fontFamily: "Aladin",
      fontSize: 35,
      fontWeight: FontWeight.bold,
      color: GlobalsColor.darkGreen,
    ),
  );

  TextField _searchTitleAppBar;

  @override
  void initState() { 
    super.initState();
    //On initialise cette Classe dans le initState pour pouvoir accéder au searchView 
    _searchTitleAppBar = TextField(
      autofocus: true,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(0),
        hintText: "Nouvelle recherche",
        focusColor: GlobalsColor.darkGreen,
        border: null,
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: GlobalsColor.darkGreen, width: 2)),
      ),
      cursorColor: Colors.black,
      onSubmitted: (String query) async {
        OnlineSearchView.currentView.searchQuery(query);
      },
      onChanged: (String query) async {
        //We launch the query on the onlineSearchView
        OnlineSearchView.currentView.searchQuery(query);
      },
    );

  }

  Future<bool> _willPopScope() async {
    if (_dispSearch) {
      setState(() => _dispSearch = false);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: _willPopScope, child: Scaffold(
      appBar: !_dispSearch ? AppBar( //Default app BAR
        leading: Icon(Icons.subscriptions,
          color: GlobalsColor.darkGreen,
          size: 38,
        ),
        title: _baseTitleAppBar,
        backgroundColor: GlobalsColor.lightGreen,
        elevation: 2,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search,
              color: GlobalsColor.darkGreen,
              size: 35,
            ),
            onPressed: () => setState(() => _dispSearch = true),
          )
        ],
      ) : AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
            color: GlobalsColor.darkGreen,
            size: 38,
          ),
          onPressed: () => setState(() => _dispSearch = false),
        ),
        title: _searchTitleAppBar,
        backgroundColor: GlobalsColor.lightGreen,
        elevation: 0,
      ),
      body: AnimatedSwitcher(
        transitionBuilder: (Widget child, Animation<double> animation) => SlideTransition(
          child: child,
          position: Tween<Offset>(
            begin: const Offset(-100, -100),
            end: const Offset(0, 0),
          ).animate(animation),
        ),
        duration: Duration(milliseconds: 0),
        child: _dispSearch ? searchView = OnlineSearchView() : HomeBodyView(),
      )
    ));
  }
}