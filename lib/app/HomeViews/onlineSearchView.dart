import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:progressive_image/progressive_image.dart';

import 'package:Videotheque/globals.dart';
import 'package:Videotheque/tmdbQueries.dart';

class OnlineSearchView extends StatefulWidget {
  //On récupère la current view
  static OnlineSearchViewState currentView;
  @override
  State<StatefulWidget> createState() {
    return currentView = OnlineSearchViewState();
  }
}

class OnlineSearchViewState extends State<OnlineSearchView> {


  static GlobalKey<OnlineSearchViewState> searchViewKey = GlobalKey<OnlineSearchViewState>();
  PageController _resultsPageController = PageController(initialPage: 0);
  Center _loading = Center( 
    child: Padding(
      padding: EdgeInsets.only(top: 55),
      child: SizedBox(
        height: 65,
        width: 65,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation(GlobalsColor.darkGreen),
        ),
      ),
    ),
  );
  QueryTypes _selectedSort = QueryTypes.all;
  String _currentQuery;
  SortingTypes _selectedSortingType = SortingTypes.defaul;
  ListView _searchResults;
  bool _dispLoading = false;
  PageView _resultsView;

  //function to reset the view when hiding it
  void reset() {
    setState(() {
      _searchResults = null;
      _dispLoading = false;
      _currentQuery = null;
    });
  }
  //Search query called from HomeHeaderView
  void searchQuery(String query, QueryTypes queryType, [SortingTypes = SortingTypes.date]) async {
    Map result;

    //Check if query is empty if yes we abort
    if (query == null || query.isEmpty) {
      setState(() => _searchResults = null);
      return;
    }
    //We display loader
    setState(() => _dispLoading = true);

    //set current query
    _currentQuery = query;
    //On fait la requête en fx de queryType
    switch (_selectedSort) {
      case QueryTypes.all:
        result = await TMDBQueries.onlineSearchMulti(query).whenComplete(() => setState(() => _dispLoading = false));
        break;
      case QueryTypes.movie:
        result = await TMDBQueries.onlineSearchMovie(query).whenComplete(() => setState(() => _dispLoading = false));
        break;
      case QueryTypes.person:
        result = await TMDBQueries.onlineSearchPerson(query).whenComplete(() => setState(() => _dispLoading = false));
        break;
      case QueryTypes.tv:
        result = await TMDBQueries.onlineSearchTV(query).whenComplete(() => setState(() => _dispLoading = false));
        break;
      case QueryTypes.collection:
        result = await TMDBQueries.onlineSearchCollection(query).whenComplete(() => setState(() => _dispLoading = false));
        break;
      case QueryTypes.companies:
        result = await TMDBQueries.onlineSearchCompanies(query).whenComplete(() => setState(() => _dispLoading = false));
        break;
    }
    print(List.from(result["results"]).length);

    //Si les results sont bons...
    if (result["results"] != null && List.from(result["results"]).length > 0) {
      //On build les résults
      _searchResults = ListView.builder(
        shrinkWrap: true,
        itemCount: result["total_results"] < 10 ? result["total_results"] : 10,
        scrollDirection: Axis.vertical,

        itemBuilder: (BuildContext context, int index) {
          //Déclaration des différents composants;
          QueryTypes elementType;
          Map element = Map.from(result["results"][index]);
          String title = ""; 
          String poster_path = "";
          IconData icon;
          Widget infos = Padding(padding: EdgeInsets.all(0));
          //Switch pour savoir sur quel element on travail
          switch (element["media_type"]) {
            case "movie":
              elementType = QueryTypes.movie;
              break;
            case "tv":
              elementType = QueryTypes.tv;
              break;
            case "person":
              elementType = QueryTypes.person;
              break;
            case "collection":
              elementType = QueryTypes.collection;
              break;
            case "company":
              elementType = QueryTypes.companies;
              break;
            default:
              elementType = queryType;
              break;
          }
          //Switch pour baser l'UI sur l'element en question
          switch (elementType) {
            case QueryTypes.movie: 
              icon = Icons.movie;
              poster_path = element["poster_path"];
              title = element["title"] != null ? element["original_title"] : null;
              infos = element["overview"] != null ? Flexible(
                child: Text(element["overview"],  
                  textWidthBasis: TextWidthBasis.parent,
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.fade,
                  maxLines: 10,
                  softWrap: true,
                ),
              ) : Padding(padding:EdgeInsets.all(0));
              break;
            case QueryTypes.tv:
              icon = Icons.tv;
              poster_path = element["poster_path"];
              title = element["name"] != null ? element["original_name"] : null;
              infos = element["overview"] != null ? Flexible(
                child: Text(element["overview"],
                  textWidthBasis: TextWidthBasis.parent,
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.fade,
                  maxLines: 10,
                  softWrap: true,
                ),
              ) : Padding(padding:EdgeInsets.all(0));
              break;
            case QueryTypes.person:
              icon = Icons.person;
              poster_path = element["profile_path"];
              title = element["name"];
              infos = element["known_for"] != null ? Flexible(
                child: Wrap(
                  children: List<Widget>.generate(List.from(element["known_for"]).length, (int index) {
                    Map knownForElement = Map.from(element["known_for"][index]);

                    return ActionChip(
                      avatar: CircleAvatar(
                        child: Icon(knownForElement["media_type"] == "movie" ? Icons.movie : Icons.tv, color: Colors.grey,),
                        backgroundColor: Colors.transparent,
                      ),
                      pressElevation: 3,
                      elevation: 1,
                      backgroundColor: Colors.transparent,
                      labelStyle: TextStyle(color: GlobalsColor.green),
                      shadowColor: GlobalsColor.darkGreenDisabled,
                      label: Text(knownForElement["title"] != null ? knownForElement["title"] : knownForElement["name"], style: TextStyle(fontSize: 13),),
                      onPressed: () {
                        //TODO: implement actionChip;
                      },
                    );
                  })
                )
              ) : Padding(padding: EdgeInsets.all(0));
              break;
            case QueryTypes.collection:
              icon = Icons.subscriptions;
              poster_path = element["poster_path"] != null ? element["poster_path"] : "";
              title = element["name"] != null ? element["name"] : "";
              break;
            case QueryTypes.companies:
              icon = Icons.business;
              poster_path = element["logo_path"];
              title = element["name"];
              break;
            default: 
              break;
          }
          return Card(
            elevation: 5,
            borderOnForeground: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
            margin: EdgeInsets.all(6),
            child: InkWell(
              onTap: () {
                
              },
              onLongPress: null,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(icon),
                    title: title != null ? Text(title) : null,
                  ),
                  Container(
                    padding: EdgeInsets.all(7),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        ProgressiveImage(
                          placeholder: AssetImage("assets/loading.png"),
                          thumbnail: NetworkImage(GlobalsData.thumbImgSize + poster_path, scale: 1),
                          image: NetworkImage(GlobalsData.imgSize + poster_path, scale: 1),
                          width: 100,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          child: Container(),
                          padding: EdgeInsets.only(left: 7),
                        ),                       
                        infos,
                      ],
                    ),
                  ),
                  Divider(
                    color: GlobalsColor.darkGreen,
                    height: 2,
                    thickness: 2,
                  ),
                ],
              ),
            ),
          );
        }
      );
    } //Si ya des erreurs on les affiches 
    else if (result["error"] != null){
      _searchResults = ListView(children: <Widget>[Center(child: Icon(Icons.error_outline, size: 20))]);
      GlobalsFunc.snackBar(context, result["error"]);
    } //Et si ya rien on met que ya rien 
    else {
      _searchResults = ListView(
        children: <Widget>[Center(child: Icon(Icons.not_interested, size: 20))]);
    }
    setState(() {
      _resultsView = PageView.builder(
        itemBuilder: (BuildContext context, int index) {
          return _searchResults;
        },
        controller: _resultsPageController,
        itemCount: GlobalsMessage.chipData.length,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints.tight(Size.fromHeight(56)),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                child: ChoiceChip(
                  pressElevation: 3,
                  elevation: 1,
                  backgroundColor: Colors.transparent,
                  avatarBorder: CircleBorder(side: BorderSide(width: 3, color: Colors.grey)),
                  selectedColor: GlobalsColor.fadedGreen,
                  labelStyle: TextStyle(color: GlobalsColor.green),
                  shadowColor: GlobalsColor.darkGreenDisabled,
                  label: Text(GlobalsMessage.chipData[index]["name"]),
                  selected: GlobalsMessage.chipData[index]["type"] == _selectedSort,
                  onSelected: (bool selected) {
                    setState(() => selected == true ? _selectedSort = GlobalsMessage.chipData[index]["type"] : null);
                    selected ? searchQuery(_currentQuery, _selectedSort, _selectedSortingType) : null;
                  },
                ),
              );
            }, 
          ),
        ),
        _resultsView, //All the pages with the results
        // Expanded(
          // child: _dispLoading ? _loading : (_searchResults != null ? _searchResults : Center(
            // child: Text("Recherchez, ajoutez, triez, le tour est joué !"),
          // )), //Loading or result
        // )
      ],
    );
  }
}