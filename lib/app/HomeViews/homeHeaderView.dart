import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:collection';
import 'package:Videotheque/globals.dart';

import 'package:Videotheque/app/HomeViews/onlineSearchView.dart';
import 'package:Videotheque/app/HomeViews/homeBodyView.dart';
import 'package:Videotheque/tmdbQueries.dart';

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
  bool _showSorting = false;
  OnlineSearchView searchView;
  QueryTypes _selectedSort;
  SortingTypes _selectedSortType = SortingTypes.defaul;
  //Base title AppBar
  final Text _baseTitleAppBar = Text("Vidéothèque",
    style: TextStyle(
      fontFamily: "Aladin",
      fontSize: 35,
      fontWeight: FontWeight.bold,
      color: GlobalsColor.darkGreen,
    ),
  );

  PopupMenuButton<SortingTypes> _popupSortMenu;
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
        OnlineSearchView.currentView.searchQuery(query, _selectedSort);
      },
      onChanged: (String query) async {
        //We launch the query on the onlineSearchView
        OnlineSearchView.currentView.searchQuery(query, _selectedSort);
      },
    );

    _popupSortMenu = PopupMenuButton<SortingTypes>(
      icon: Icon(Icons.filter_list,
        color: GlobalsColor.darkGreen,
        size: 35,
      ),
      elevation: 3.2,
      initialValue: _selectedSortType,
      onSelected: (SortingTypes selected) => _selectedSortType = selected,
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[Icon(Icons.star, color: Colors.grey,), Padding(padding: EdgeInsets.only(left: 4)), Text("Trier par pertinence")]), value: SortingTypes.defaul),
        PopupMenuItem(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[Icon(Icons.sort_by_alpha, color: Colors.grey,), Padding(padding: EdgeInsets.only(left: 4)), Text("Trier alphabétiquement")]), value: SortingTypes.alpha),
        PopupMenuItem(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[Icon(Icons.access_time, color: Colors.grey,), Padding(padding: EdgeInsets.only(left: 4)), Text("Trier par date")]), value: SortingTypes.date),
      ],
      offset: Offset(0, 118),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( //Default app BAR
        leading: IconButton(
          icon: Icon(_dispSearch ? Icons.arrow_back : Icons.subscriptions,
            color: GlobalsColor.darkGreen,
            size: 38,
          ),
          onPressed: _dispSearch ? () => setState(() { _dispSearch = false; OnlineSearchView.currentView.reset();}) : null,
        ),
        title: _dispSearch ? _searchTitleAppBar : _baseTitleAppBar,
        backgroundColor: GlobalsColor.lightGreen,
        actions: <Widget>[
          _dispSearch ? _popupSortMenu : IconButton(
            icon: Icon(Icons.search,
              color: GlobalsColor.darkGreen,
              size: 35,
            ),
            onPressed: () => setState(() => _dispSearch = true),
          )
        ],
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
    );
  }
}