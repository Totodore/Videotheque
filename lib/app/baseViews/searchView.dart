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

class SearchView extends StatefulWidget {
  //On récupère la current view
  @override
  State<StatefulWidget> createState() {
    return SearchViewState();
  }
}

class SearchViewState extends State<SearchView> with TickerProviderStateMixin {

  static GlobalKey<SearchViewState> searchViewKey = GlobalKey<SearchViewState>();

  static final Duration _animationInitDelay = Duration(milliseconds: 500); 

  TabController _resultsPageController;
  TextEditingController _searchInputController = TextEditingController();
  FocusNode _inputFocusNode = FocusNode();
  QueryTypes _selectedSort = QueryTypes.all;
  String _currentQuery;
  List<Widget> _resultsView;
  bool _dispAnimationHomeSearch = false;
  Future _delayOkSearch;
  // double _oldOffsetScroll = 0;

  Map<QueryTypes, dynamic> _loadedSiblings; //List which represent number of view loaded
  //List which represent offset of result per view
  Map<QueryTypes, List> _dataLoadedView = Map.fromIterables(QueryTypes.values, List.generate(QueryTypes.values.length, (int index) {return null;})); 
  //offset actuel de chaque view
  // Map<QueryTypes, int> _offsetLoadedView = Map.fromIterables(QueryTypes.values, List.generate(QueryTypes.values.length, (int index) {return 1;}));
  //si on a atteint le bas du bottom correspondant à la view
  Map<QueryTypes, bool> _reachBottomLoadedView = Map.fromIterables(QueryTypes.values, List.generate(QueryTypes.values.length, (int index) {return false;}));

  @override 
  void initState() {
    super.initState();

    _resultsPageController = TabController(vsync: this, length: QueryTypes.values.length, initialIndex: 0);
    _resultsPageController.addListener(() {
      setState(() {
        _selectedSort = QueryTypes.values[_resultsPageController.index];
      });
    });
    //Si on arrive en bas de page
    // _pageResultsController.addListener(() async {
    //   QueryTypes actualQueryType = QueryTypes.values[_resultsPageController.index];

    //   if (_pageResultsController.offset > _pageResultsController.position.maxScrollExtent - 40 && !_reachBottomLoadedView[actualQueryType]) {
    //     //On incrémente l'offset correspondant à la view actuelle
    //     _offsetLoadedView[actualQueryType] += 1;
    //     _reachBottomLoadedView[actualQueryType] = true; //On dit qu'on a attein le bottom de la view
    //     searchQuery(_currentQuery, _offsetLoadedView[actualQueryType]);
    //   }
    //   //On scroll down we hide keyboard and we hide SearchBar
    //   if (_pageResultsController.offset > _oldOffsetScroll && _inputFocusNode.hasFocus) {
    //     _inputFocusNode.unfocus();
    //   }
    //   _oldOffsetScroll = _pageResultsController.offset;
    // });
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        _dispAnimationHomeSearch = true;
      });
    });
  }

  void clearView() {
    _searchInputController.clear();
    setState(() {
      _currentQuery = null;
      _resultsView = null;
      _loadedSiblings = null; //List which represent number of view loaded
      _dataLoadedView = Map.fromIterables(QueryTypes.values, List.generate(QueryTypes.values.length, (int index) {return null;})); 
      // _offsetLoadedView = Map.fromIterables(QueryTypes.values, List.generate(QueryTypes.values.length, (int index) {return 1;}));
      _reachBottomLoadedView = Map.fromIterables(QueryTypes.values, List.generate(QueryTypes.values.length, (int index) {return false;}));
      _dispAnimationHomeSearch = false;
      Future.delayed(const Duration(milliseconds: 10), () {
        setState(() {
          _dispAnimationHomeSearch = true;
        });
      });
    });
  }

  Future<List<Widget>> buildView(QueryTypes queryType, [int offset = 1]) async {
    Map result;
    List<Widget> _searchResults;

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

      _searchResults = List.generate(_dataLoadedView[queryType].length, (int index) {
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
          Color iconColor = GlobalsMessage.chipData[QueryTypes.values.indexOf(elementType)]["color"];
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
                  spacing: 5,
                  runSpacing: 0,
                  children: List<Widget>.generate(List.from(element["known_for"]).length, (int index) {
                    Map knownForElement = Map.from(element["known_for"][index]);
                    return Theme(
                      data: Theme.of(context).copyWith(splashColor: GlobalsColor.darkGreenDisabled),
                      child: ActionChip(
                        avatar: CircleAvatar(
                          child: Icon(knownForElement["media_type"] == "movie" ? Icons.movie : Icons.tv, color: GlobalsColor.darkGreen),
                          backgroundColor: Colors.transparent,
                        ),
                        labelStyle: TextStyle(color: GlobalsColor.green),
                        label: Text(knownForElement["title"] != null ? knownForElement["title"] : knownForElement["name"], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        onPressed: () {
                          String route = "/element/"+GlobalsMessage.chipData[1]["route"] + "/";
                          GlobalsArgs.actualRoute = route;
                          GlobalsArgs.transfertArg = List.from([knownForElement, ""]);
                          Navigator.pushNamed(context, route, arguments: element);
                        },
                      ),
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
            elevation: 2,
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
                    leading: Icon(icon, color: iconColor),
                    title: title != null ? Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),) : null,
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 7, left: 7, bottom: 7, top:0),
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
      _searchResults = <Widget>[
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
        ];
      GlobalsFunc.snackBar(context, result["error"]);
    } //Et si ya rien on met que ya rien 
    else {
      _searchResults = <Widget>[
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
      ];
    }

    return _searchResults;
  }

  //Search handler which determine which view should be loaded recursively
  void handleBuildView(bool newQuery, int index, [int offset = 1]) {
    QueryTypes queryType = QueryTypes.values[index];
    //Quand on a fini de get la view,
    buildView(queryType, offset).then((List<Widget> newView) {
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

  Widget buildSkeleton() {
    return Card(
      elevation: 2,
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
            padding: EdgeInsets.only(right: 7, left: 7, bottom: 7, top:0),
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
  }

  void buildListView() {
    setState(() {
      _resultsView = List.generate(QueryTypes.values.length, (index) {
        return SafeArea(
          top: false,
          bottom: false,
          child: Builder(builder: (BuildContext context) {
            return CustomScrollView(
              physics: BouncingScrollPhysics(),
              key: PageStorageKey<String>(QueryTypes.values[index].toString()),
              slivers: <Widget>[
                SliverOverlapInjector(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int indexEl) {
                      if (_loadedSiblings[QueryTypes.values[index]] != false)
                        return _loadedSiblings[QueryTypes.values[index]][indexEl];
                      else return buildSkeleton();
                    },
                    childCount: _loadedSiblings[QueryTypes.values[index]] != false ? _loadedSiblings[QueryTypes.values[index]].length : 20
                  ),
                  // itemExtent: 300,
                )
              ],
            );
          }),
        );
      });
    });
  }

  Widget buildIconSearch() {
    return AnimatedOpacity(
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
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: QueryTypes.values.length,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool isInnerBoxScrolled) {
          return <Widget>[ SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverSafeArea(
              top: false,
              sliver: SliverAppBar(
                elevation: 3,
                forceElevated: isInnerBoxScrolled,
                floating: true,
                pinned: true,
                snap: true,
                backgroundColor: GlobalsColor.darkGreen,
                centerTitle: true,
                expandedHeight: 2*kToolbarHeight-5,
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
                    //We launch the query on the SearchView
                    if (_delayOkSearch != null) { //Si ya un future en cours on l'annule
                      _delayOkSearch.timeout(Duration(microseconds: 0)).catchError((onError) => print("future canceled"));
                    } 
                    //On créé un nouveau future qui va lancera la query
                    _delayOkSearch = Future.delayed(Duration(milliseconds: 750), () {
                      _delayOkSearch = null;
                      searchQuery(query);
                    });
                  },
                ),
                leading: AnimatedSwitcher(
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
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight - 6), 
                  child: Material(
                    child: Theme(
                      data: ThemeData(highlightColor: Colors.transparent, splashColor: Colors.transparent, accentColor: GlobalsColor.darkGreenDisabled),
                      child: TabBar(
                        indicator: UnderlineTabIndicator(borderSide: BorderSide.none),
                        onTap: (int index) {
                          setState(() {
                            _selectedSort = QueryTypes.values[index];
                          });
                        },
                        controller: _resultsPageController,
                        isScrollable: true,
                        labelPadding: EdgeInsets.symmetric(horizontal: 8),
                        tabs: List<Widget>.generate(GlobalsMessage.chipData.length, (int index) {
                          return Theme(data: Theme.of(context).copyWith(splashColor: GlobalsMessage.chipData[index]["splash_color"]),child: ChoiceChip(
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
                              _resultsPageController.animateTo(index, duration: Duration(milliseconds: 200));
                            }),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            ), 
          )]; 
        },
        body: TabBarView(
          controller: _resultsPageController,
          children: _resultsView != null ? _resultsView : List.generate(QueryTypes.values.length, (int index) => buildIconSearch())
        ),
      )
    );
  }
}