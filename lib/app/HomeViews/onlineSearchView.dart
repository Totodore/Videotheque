import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:uuid/uuid.dart';


import 'package:Videotheque/globals.dart';
import 'package:Videotheque/tmdbQueries.dart';

class OnlineSearchView extends StatefulWidget {
  //On récupère la current view
  @override
  State<StatefulWidget> createState() {
    return OnlineSearchViewState();
  }
}

class OnlineSearchViewState extends State<OnlineSearchView> {

  static GlobalKey<OnlineSearchViewState> searchViewKey = GlobalKey<OnlineSearchViewState>();

  static final Duration _animationInitDelay = Duration(milliseconds: 500); 

  PageController _resultsPageController = PageController(initialPage: 0, keepPage: true);
  ScrollController _pageResultsController = ScrollController(keepScrollOffset: true);
  ScrollController _rowChipTypeController = ScrollController(keepScrollOffset: true);
  TextEditingController _searchInputController = TextEditingController();
  FocusNode _inputFocusNode = FocusNode();
  QueryTypes _selectedSort = QueryTypes.all;
  String _currentQuery;
  PageView _resultsView;
  bool _dispAnimationHomeSearch = false;
  bool _endAnimationHomeSearch = false;
  Future _delayOkSearch;
  double _appBarElevation = 0;
  double _sortBarTop = GlobalsData.initSortBarPos;
  double _oldOffsetScroll = 0;

  Map<QueryTypes, dynamic> _loadedSiblings; //List which represent number of view loaded
  //List which represent offset of result per view
  Map<QueryTypes, List> _dataLoadedView = Map.fromIterables(QueryTypes.values, List.generate(QueryTypes.values.length, (int index) {return null;})); 
  //offset actuel de chaque view
  Map<QueryTypes, int> _offsetLoadedView = Map.fromIterables(QueryTypes.values, List.generate(QueryTypes.values.length, (int index) {return 1;}));
  //si on a atteint le bas du bottom correspondant à la view
  Map<QueryTypes, bool> _reachBottomLoadedView = Map.fromIterables(QueryTypes.values, List.generate(QueryTypes.values.length, (int index) {return false;}));

  @override 
  void initState() {
    super.initState();

    //Quand on scroll latéralement on fait bouger les chips aussi
    _resultsPageController.addListener(syncScrollBar);
    
    //Si on arrive en bas de page
    _pageResultsController.addListener(() async {
      QueryTypes actualQueryType = QueryTypes.values[_resultsPageController.page.toInt()];

      if (_pageResultsController.offset > _pageResultsController.position.maxScrollExtent - 40 && !_reachBottomLoadedView[actualQueryType]) {
        //On incrémente l'offset correspondant à la view actuelle
        _offsetLoadedView[actualQueryType] += 1;
        _reachBottomLoadedView[actualQueryType] = true; //On dit qu'on a attein le bottom de la view
        searchQuery(_currentQuery, _offsetLoadedView[actualQueryType]);
      }
      //Si on scroll vers le bas et que la barre est affichée on la cache
      if (_pageResultsController.position.pixels > 5) {
        setState(() => _appBarElevation = 3);
      }
      else  {//Sinon on l'affiche;
        setState(() => _appBarElevation = 0);
      }
      //On scroll down we hide keyboard and we hide SearchBar
      if (_pageResultsController.offset > _oldOffsetScroll && _sortBarTop > GlobalsData.endSortBarPos) {
        _sortBarTop -= _pageResultsController.offset - _oldOffsetScroll;
        _sortBarTop < GlobalsData.endSortBarPos ? _sortBarTop = GlobalsData.endSortBarPos : null;
        _inputFocusNode.unfocus();
        // _pageResultsController.animateTo(_oldOffsetScroll, duration: Duration(milliseconds: 0), curve: Curves.linear);
      }
      //On scroll up we show SearchBar
      else if (_pageResultsController.offset < _oldOffsetScroll && _sortBarTop < GlobalsData.initSortBarPos) {
        _sortBarTop += _oldOffsetScroll - _pageResultsController.offset;
        _sortBarTop > GlobalsData.initSortBarPos ? _sortBarTop = GlobalsData.initSortBarPos : null;
        // _pageResultsController.animateTo(_oldOffsetScroll, duration: Duration(milliseconds: 0), curve: Curves.linear);
      }
      _oldOffsetScroll = _pageResultsController.offset;
      // if (_pageResultsController.position.pixels )
    });
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        _dispAnimationHomeSearch = true;
      });
      Future.delayed(_animationInitDelay, () {
        setState(() {
          _endAnimationHomeSearch = true;
        });
      });
    });
    //On delay ca pour avoir accès au context
    Future.delayed(Duration.zero, () {
      setState(() {
          GlobalsData.endSortBarPos = MediaQuery.of(context).padding.top;
          GlobalsData.initSortBarPos = 59 + GlobalsData.endSortBarPos;
          _sortBarTop = GlobalsData.initSortBarPos;
      });
    });
  }

  //Scrollbar horizontal for page View
  void syncScrollBar() async {
      //Sync ScrollBar page View with sort Bar 
      double ratio = _resultsPageController.offset/_resultsPageController.position.maxScrollExtent;
      double animatePos = _rowChipTypeController.position.maxScrollExtent*ratio;
      setState(() => _appBarElevation = 0);
      _rowChipTypeController.animateTo(
        animatePos,
        duration: Duration(milliseconds: 200),
        curve: Curves.linear
      );
      //Show titleBar on slide ScrollBar
      double pageWidth = _resultsPageController.position.maxScrollExtent/GlobalsMessage.chipData.length;
      //Offset between the two pages
      double actualRelativeOffset;
      if (_resultsPageController.position.userScrollDirection == ScrollDirection.forward)
        actualRelativeOffset = _resultsPageController.offset - (_resultsPageController.page.floor())*(pageWidth+60);
      else
        actualRelativeOffset = _resultsPageController.offset - (_resultsPageController.page.ceil())*(pageWidth+60);
      double ratioRelativeOffset = (actualRelativeOffset/pageWidth).abs()/1.2;
      print("Ratio : " + ratioRelativeOffset.toString());
      setState(() {
        if (_sortBarTop < GlobalsData.initSortBarPos && _sortBarTop >= GlobalsData.endSortBarPos) {
          _sortBarTop = GlobalsData.deltaSortBarPos*(1-ratioRelativeOffset) + GlobalsData.endSortBarPos;
          print(_sortBarTop);
        }
      });
  }

  void clearView() {
    _searchInputController.clear();
    setState(() {
      _currentQuery = null;
      _resultsView = null;
      _loadedSiblings = null; //List which represent number of view loaded
      _dataLoadedView = Map.fromIterables(QueryTypes.values, List.generate(QueryTypes.values.length, (int index) {return null;})); 
      _offsetLoadedView = Map.fromIterables(QueryTypes.values, List.generate(QueryTypes.values.length, (int index) {return 1;}));
      _reachBottomLoadedView = Map.fromIterables(QueryTypes.values, List.generate(QueryTypes.values.length, (int index) {return false;}));
      _dispAnimationHomeSearch = false;
      Future.delayed(const Duration(milliseconds: 10), () {
        setState(() {
          _dispAnimationHomeSearch = true;
        });
      });
    });
  }

  Future<ListView> buildView(QueryTypes queryType, [int offset = 1]) async {
    Map result;
    ListView _searchResults;

    //On fait la requête en fx de queryType
    switch (queryType) {
      case QueryTypes.all:
        result = await TMDBQueries.onlineSearchMulti(_currentQuery, offset);
        break;
      case QueryTypes.movie:
        result = await TMDBQueries.onlineSearchMovie(_currentQuery, offset);
        break;
      case QueryTypes.person:
        result = await TMDBQueries.onlineSearchPerson(_currentQuery, offset);
        break;
      case QueryTypes.tv:
        result = await TMDBQueries.onlineSearchTV(_currentQuery, offset);
        break;
      case QueryTypes.collection:
        result = await TMDBQueries.onlineSearchCollection(_currentQuery, offset);
        break;
      case QueryTypes.companies:
        result = await TMDBQueries.onlineSearchCompanies(_currentQuery, offset);
        break;
    }

    if (result["total_pages"] == offset || result["results"] == null || List.from(result["results"]).length == 0) {
      //Si c'est la dernière page de la view ou que ya plus de résultat on dit qu'on a atteint le bottom
      _reachBottomLoadedView[queryType] = true;
    } else {
      //Si ya encore des résultats alors on a pas encore atteint le fond
      _reachBottomLoadedView[queryType] = false;
    }
    //Si les results sont bons...
    if (result["results"] != null && List.from(result["results"]).length > 0) {
      //On build les résults
      print("building " + queryType.toString() + " " + offset.toString());
      if (offset == 1)
        _dataLoadedView[queryType] = result["results"]; 
      else 
        _dataLoadedView[queryType].addAll(result["results"]);

      _searchResults = ListView.builder(
        controller: _pageResultsController,
        itemCount: _dataLoadedView[queryType].length,
        scrollDirection: Axis.vertical,

        itemBuilder: (BuildContext context, int index) {
          //Déclaration des différents composants;
          QueryTypes elementType;
          Map element = Map.from(_dataLoadedView[queryType][index]);
          String title = ""; 
          String posterPath = "";
          String heroTag = Uuid().v1();
          IconData icon;
          Widget infos = Container();
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
              posterPath = element["poster_path"];
              title = element["title"] != null ? element["original_title"] : null;
              infos = element["overview"] != null ? Flexible(
                child: Text(element["overview"],  
                  textWidthBasis: TextWidthBasis.parent,
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.fade,
                  maxLines: 10,
                  softWrap: true,
                ),
              ) : Container();
              break;
            case QueryTypes.tv:
              icon = Icons.tv;
              posterPath = element["poster_path"];
              title = element["name"] != null ? element["original_name"] : null;
              infos = element["overview"] != null ? Flexible(
                child: Text(element["overview"],
                  textWidthBasis: TextWidthBasis.parent,
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.fade,
                  maxLines: 10,
                  softWrap: true,
                ),
              ) : Container();
              break;
            case QueryTypes.person:
              icon = Icons.person;
              posterPath = element["profile_path"];
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
                      labelStyle: TextStyle(color: GlobalsColor.green),
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
              posterPath = element["poster_path"] != null ? element["poster_path"] : "";
              title = element["name"] != null ? element["name"] : "";
              break;
            case QueryTypes.companies:
              icon = Icons.business;
              posterPath = element["logo_path"];
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
                String route = "/element/"+GlobalsMessage.chipData[QueryTypes.values.indexOf(elementType)]["route"] + "/";
                GlobalsArgs.actualRoute = route;
                GlobalsArgs.transfertArg = List.from([element, heroTag]);
                Navigator.pushNamed(context, route, arguments: element);
              },
              onDoubleTap: null,
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
                        posterPath != null ? Hero(
                          tag: heroTag, 
                          transitionOnUserGestures: true, 
                          child: ProgressiveImage(
                            placeholder: AssetImage("assets/loading.png"),
                            thumbnail: NetworkImage(GlobalsData.thumbImgSize + posterPath, scale: 1),
                            image: NetworkImage(GlobalsData.imgSize + posterPath, scale: 1),
                            width: 100,
                            height: 150,
                            fit: BoxFit.cover,
                            fadeDuration: Duration(milliseconds: 150),
                            blur: 2,
                          )
                        ) : Container(),
                        Padding(
                          child: Container(),
                          padding: EdgeInsets.only(left: 7),
                        ),                       
                        infos,
                      ],
                    ),
                  ),
                  Divider(
                    color: GlobalsMessage.chipData[QueryTypes.values.indexOf(elementType)]["color"],
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
      _searchResults = ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 100), 
            child: Center(
              child: Icon(Icons.error_outline, 
                size: 100
              )
            )
          ),
          Text(GlobalsMessage.defaultError,
            textAlign: TextAlign.center,
          )
        ]
      );
      GlobalsFunc.snackBar(context, result["error"]);
    } //Et si ya rien on met que ya rien 
    else {
      _searchResults = ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 75, bottom: 25), 
            child: Center(
              child: Icon(Icons.not_interested, 
                size: 100
              )
            )
          ),
          Text(GlobalsMessage.noResults,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w500),
          )
        ]
      );
    }

    return _searchResults;
  }

  //Search handler which determine which view should be loaded recursively
  void handleBuildView(bool newQuery, int index, [int offset = 1]) {
    QueryTypes queryType = QueryTypes.values[index];
    //Quand on a fini de get la view,
    buildView(queryType, offset).then((ListView newView) {
      //On la rajoute dans la liste des views loadés
      _loadedSiblings[queryType] = newView;
      buildListView();  //On rebuild le tout avec la nouvelle view
      //Pour chaque view dans la liste si yen a une pas loadé on fait la load et ainsi de suite
      //Seulement si c'est une nouvelle requête
      if (newQuery) {
        for (var item in QueryTypes.values) {
          if (_loadedSiblings[item] == false) {
            handleBuildView(true, item.index);
            break;  //On break quand on en a trouvé une a loader
          }
        }
      }
    });
  }
  //Search query called from HomeHeaderView or called recursively to load 
  void searchQuery(String query, [int offset = 1]) async {

    if (offset == 1) {
      //Si c'est une nouvelle requete on réinitialise les données
      _loadedSiblings = Map.fromIterables(QueryTypes.values, List.generate(QueryTypes.values.length, (int index) {return false;}));
    }
    //Check if query is empty if yes we abort
    if (query == null || query.isEmpty) {
      clearView();
      return;
    }

    //Si c'est pas une nouvelle requête
    if (query != _currentQuery) {
      _currentQuery = query;
    }
    handleBuildView(true, QueryTypes.values.indexOf(_selectedSort), offset);

    buildListView();
  }

  ListView buildSkeleton() {
    return ListView.builder(itemCount: QueryTypes.values.length, controller: _pageResultsController,itemBuilder: (BuildContext context, int index) {
      return Card(
        elevation: 5,
        borderOnForeground: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
        margin: EdgeInsets.all(6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile( //Skeleton for title
              title: SkeletonAnimation(child: Container(
                width: MediaQuery.of(context).size.width*0.7, 
                height: 25, 
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
              )),
            ),
            Container(
              padding: EdgeInsets.all(7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[ //Skeleton for image
                  SkeletonAnimation(
                    child: Container(
                      width: 100,
                      height: 150,
                      color: Colors.grey[300],
                    ),
                  ),
                  Padding(  //Skeleton for text
                    padding: EdgeInsets.only(left: 20, top: 8),
                    child: Column(children: List.generate(7, (int index) {
                      return Padding(padding: EdgeInsets.only(bottom: 7), child: Theme(
                        data: ThemeData(backgroundColor: Colors.grey[300]),
                        child: SkeletonAnimation(
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.55, 
                            height: 13,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                            ),
                          )
                        )
                      ));
                    })),            
                  ),
                ],
              ),
            ),
            Divider(
              color: GlobalsMessage.chipData[1]["color"],
              height: 2,
              thickness: 2,
            ),
          ],
        ),
      );      
    });
  }

  void buildListView() {
    setState(() {
      _resultsView = PageView.builder(
        controller: _resultsPageController,
        onPageChanged: (int index) {
          setState(() {
            _selectedSort = QueryTypes.values[index];
          });
        },
        itemCount: QueryTypes.values.length,
        itemBuilder: (BuildContext context, int index) {
          if (_loadedSiblings[QueryTypes.values[index]] != false) {
            return _loadedSiblings[QueryTypes.values[index]];
          } else {
            return buildSkeleton();
          }
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(175 + GlobalsData.endSortBarPos),
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
                ClipRRect(
                  // borderRadius: BorderRadius.circular(50),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                  // clipper: OvalRightBorderClipper(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: GlobalsColor.darkGreen,
                    ),
                    padding: EdgeInsets.only(left: 5, top: GlobalsData.endSortBarPos, right: 10, bottom: 3),
                    margin: EdgeInsets.only(bottom: _sortBarTop - 23),
                    child: ListTile(  
                      contentPadding: EdgeInsets.all(0),
                      leading: Container( 
                        height: 35,
                        width: 35,
                        margin: EdgeInsets.only(left: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withAlpha(50),
                        ),
                        padding: EdgeInsets.all(0),
                        child: AnimatedSwitcher(
                          child: _searchInputController.text.length > 0 ? IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(Icons.close,
                              size: 28,
                            ),
                            onPressed: () => clearView(),
                          ) : IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(
                              Icons.search,
                              size: 28,

                            ),
                            onPressed: null,                          
                          ),
                          duration: Duration(milliseconds: 300)
                        ),
                      ),
                      title: TextField(
                        focusNode: _inputFocusNode,
                        controller: _searchInputController,
                        textInputAction: TextInputAction.search,
                        cursorColor: Color(0xFFebebeb),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: -6),
                          hintText: "Nouvelle recherche",
                          focusColor: GlobalsColor.darkGreen,
                          border: InputBorder.none,
                          focusedBorder: null,
                          hintStyle: TextStyle(
                            color: Color(0xFFebebeb).withAlpha(180)
                          )
                        ),   
                        style: TextStyle(
                          color: Color(0xFFebebeb),
                          fontSize: 18.5,
                          fontWeight: FontWeight.w400
                        ),
                        onSubmitted: (String query) async {
                          searchQuery(query);
                        },
                        onChanged: (String query) async {
                          //We launch the query on the onlineSearchView
                          if (_delayOkSearch != null) { //Si ya un future en cours on l'annule
                            _delayOkSearch.timeout(Duration(microseconds: 0)).catchError((onError) => print("future canceled"));
                          } 
                          //On créé un nouveau future qui va lancera la query
                          _delayOkSearch = Future.delayed(Duration(milliseconds: 500), () {
                            _delayOkSearch = null;
                            searchQuery(query);
                          });
                        },
                      ),
                    ),
                  ),
                ),
              AnimatedPositioned(
                duration: _animationInitDelay,
                curve: Curves.ease,
                top: _dispAnimationHomeSearch ? _sortBarTop : GlobalsData.endSortBarPos,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[600],
                        blurRadius: 3,
                        offset: Offset(0, 5),
                        spreadRadius: -5
                      ),
                    ],
                    color: Colors.white
                  ),
                  margin: EdgeInsets.only(top: 0),
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _rowChipTypeController,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: List<Widget>.generate(GlobalsMessage.chipData.length, (int index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                          child: Theme(data: Theme.of(context).copyWith(splashColor: GlobalsMessage.chipData[index]["splash_color"]),child: ChoiceChip(
                            labelStyle: TextStyle(color: GlobalsMessage.chipData[index]["color"], fontWeight: FontWeight.w600),
                            selectedColor: GlobalsMessage.chipData[index]["selected_color"],
                            label: Row(children: <Widget>[
                              Icon(
                                GlobalsMessage.chipData[index]["icon"], 
                                color: GlobalsMessage.chipData[index]["color"]
                              ), 
                                Padding(padding: EdgeInsets.only(right: 10)), 
                                Text(GlobalsMessage.chipData[index]["name"])
                            ]),
                            selected: GlobalsMessage.chipData[index]["type"] == _selectedSort,
                            onSelected: (bool selected) {
                              setState(() => selected == true ? _selectedSort = GlobalsMessage.chipData[index]["type"] : null);
                              //Si la liste view est créée on la fait bouger
                              if (_resultsPageController.hasClients && selected) {
                                _resultsPageController.animateToPage(index, curve: Curves.ease, duration: Duration(milliseconds: 200));
                              }
                              //Sinon on met la page initial
                              else if (!_resultsPageController.hasClients && selected){
                                setState(() {
                                  _resultsPageController = PageController(initialPage: index);
                                  _resultsPageController.addListener(syncScrollBar);                          
                                });
                              }
                            }),
                          )
                        );
                      }),
                    )),
                  )
              ),
            ]
          )
      ),
      body: Theme(
        data: Theme.of(context).copyWith(accentColor: GlobalsColor.darkGreen),
        child: Padding(
          padding: EdgeInsets.only(top: 0),
          child: _resultsView != null ? _resultsView : AnimatedOpacity(
            opacity: _dispAnimationHomeSearch ? 1 : 0,
            duration: _animationInitDelay, 
            curve: Curves.ease,
            child: AnimatedContainer(
              duration: _animationInitDelay,
              curve: Curves.ease,
              transform: _dispAnimationHomeSearch ? Matrix4.translationValues(0, 0, 0) : Matrix4.translationValues(0, 50, 0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 65, bottom: 25), 
                    child: Center(
                      child: Icon(Icons.local_movies,
                        size: 100
                      )
                    )
                  ),
                  Text(GlobalsMessage.defaultSearchMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
          ),
        ),
      ) //All the pages with the results
    );
  }
}