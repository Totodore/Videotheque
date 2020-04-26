import 'dart:ui';

import 'package:Videotheque/globals.dart';
import 'package:Videotheque/tmdbQueries.dart';
import 'package:community_material_icon/community_material_icon.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:background_app_bar/background_app_bar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class MovieView extends StatefulWidget {
  static ScrollController scrollController = ScrollController();

  @override
  State<StatefulWidget> createState() {
    return MovieViewState();
  }
}

class MovieViewState extends State<MovieView> with TickerProviderStateMixin {

  Map _preLoadData = Map();
  Map _infosMap = {};
  Map _genreList = {};
  Map _creditsMap = {};
  Map _similarMap = {};
  Map _trailerMap = {};
  Map<String, Widget> _ownGenreList = {};
  Map<String, Widget> _selectedTags = {};
  Map<String, String> _ownGenreIds = {};

  AnimationController _menuAnimationController;
  AnimationController _chipShakeAnimationController;

  FocusNode _addTagFocusNode = FocusNode();
  TextEditingController _addTagController = TextEditingController();

  bool _dispGenreList = false;
  bool _dispInfoList = false;
  bool _dispCredits = false;
  bool _dispSimilar = false;
  bool _dispMovieTrailer = false;
  
  bool _forceHideTag = false;

  @override
  void initState() {
    _preLoadData = GlobalsArgs.transfertArg[0];
    _menuAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _chipShakeAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 50),
    );
    _chipShakeAnimationController.repeat();

    getTagList();
    getInfoList();
    getMovieCredits();
    getMovieSimilar();
    getMovieTrailer();

    super.initState();

    
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _keyboardIsVisible() {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  Widget buildGenreTags() {
    List<String> tagNames = [];
    List<Widget> tagsChips = List<Widget>.generate(_preLoadData["genre_ids"].length, (int index) {
      int tagId = _preLoadData["genre_ids"][index];
      String tagName;
      for (Map element in _genreList["genres"]) {
        if (element["id"] == tagId) {
          tagName = element["name"];
          break;
        }
      }
      tagNames.add(tagName.toLowerCase());
      return ActionChip(
        label: Text(tagName),
        labelStyle: TextStyle(color: GlobalsColor.darkGreen, fontWeight: FontWeight.w600),
        avatar: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(Icons.label_outline, color: GlobalsColor.darkGreen),
        ),
        onPressed: () {
          print(tagId);
        },
        
      );
    });
    //Pour chaque tag non ajouté dans la liste on en créé un nouveau avec un nouvel id compris
    for (String key in _ownGenreList.keys) {
      if (!tagNames.contains(key.toLowerCase())) {
        tagsChips.add(
          ActionChip(
            label: Text(key),
            labelStyle: TextStyle(color: GlobalsColor.darkGreen, fontWeight: FontWeight.w600),
            avatar: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.label, color: GlobalsColor.darkGreen),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide(width: 0.7, style: BorderStyle.solid, color: GlobalsColor.darkGreen)
            ),
            onPressed: () {
              print(key);
            },
          )
        );
        _ownGenreIds[Uuid().v1()] = key;
      }
    }
    tagsChips.add(ActionChip(
      labelStyle: TextStyle(color: GlobalsColor.darkGreen, fontWeight: FontWeight.w600),
      label: Icon(Icons.edit, color: GlobalsColor.darkGreen),
      onPressed: () {
        _addTagFocusNode.requestFocus();
      },
    ));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        spacing: 8,
        runSpacing: 0,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: tagsChips,
      ),
    );
  }

  Widget buildInfoTags() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        spacing: 8,
        runSpacing: 0,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: List<Widget>.generate(_infosMap.length, (int index) {
          if (_infosMap[_infosMap.keys.toList()[index]] == null) {
            return Padding(padding: EdgeInsets.all(0));
          }
          return ActionChip(
            label: Text(_infosMap[_infosMap.keys.toList()[index]]),
            labelStyle: TextStyle(color: GlobalsColor.darkGreen, fontWeight: FontWeight.w600),
            avatar: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.info_outline, color: GlobalsColor.darkGreen),
            ),
            onPressed: () {},
          );
        }),
      ),
    );
  }

  Widget buildCaroussel(data, QueryTypes type) {
    var toRemove = [];
    //Si ya plusieurs fois la même personne on enlève
    if (type == QueryTypes.person) {
      for(var i = 0; i<data.length; i++){
        var ele = data[i];
        if (ele["poster_path"] == null && ele["profile_path"] == null) {
          toRemove.add(ele);
          continue;
        }
        for(var i2 = i+1;i2<data.length;i2++){
          var ele2 = data[i2];
          if(ele["id"] == ele2["id"])
            toRemove.add(ele2);
        }
      }
      for(var ele in toRemove)
        data.remove(ele);
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: List.generate(data.length, (int index) {
            String name;
            String img_url;
            String heroTag = Uuid().v1();

            String route = "/element/"+GlobalsMessage.chipData[QueryTypes.values.indexOf(type)]["route"] + "/";
            GlobalsArgs.actualRoute = route;

            if (type == QueryTypes.person) {
              img_url = data[index]["profile_path"];
              name = data[index]["name"];
            } else if (type == QueryTypes.movie) {
              img_url = data[index]["poster_path"];
              name = data[index]["title"];       
            }

            return Card(
              elevation: 1,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: InkWell(
                  onTap: () {
                    GlobalsArgs.transfertArg = [data[index], heroTag];
                    Navigator.pushNamed(context, route);
                  },
                  splashColor: GlobalsMessage.chipData[1]["splash_color"],
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                        // clipBehavior: Clip.hardEdge,
                        child: Hero(
                          tag: heroTag,
                          child: ProgressiveImage(
                            placeholder: AssetImage("assets/loading.png"),
                            thumbnail: NetworkImage(GlobalsData.thumbImgSize + img_url, scale: 1),
                            image: NetworkImage(GlobalsData.imgSize + img_url, scale: 1),
                            width: 120,
                            height: 150,
                            fit: BoxFit.cover,
                            fadeDuration: Duration(milliseconds: 150),
                            blur: 2,                      
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                        width: 120,
                        child: Text(name, 
                          style: TextStyle(fontWeight: FontWeight.w700),
                          maxLines: 5,
                          softWrap: true,
                          textWidthBasis: TextWidthBasis.parent,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
            );
          })
        ),
      ),
    );
  }

  Widget buildTagChipInput(String tag) {
    ActionChip inputChip;
    inputChip = ActionChip(
        label: Text(tag),
        labelStyle: TextStyle(color: GlobalsColor.darkGreen, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(width: 0.7, style: BorderStyle.solid, color: GlobalsColor.darkGreen)
        ),
        avatar: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(Icons.label, color: GlobalsColor.darkGreen),
        ),
        onPressed: () {
          setState(() {
            _selectedTags.removeWhere((key, value) => (key == tag));
          });
        },
      );
    return inputChip;
  }

  Widget buildTagInput() {
    return Column(
      children: <Widget>[
        Container(
          height: 50,
          margin: EdgeInsets.zero,  
          padding: EdgeInsets.zero,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: AnimatedSwitcher(
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(child: child, scale: animation);
              },
              duration: Duration(milliseconds: 200),
              child: _selectedTags.length > 0 ? Wrap(
                direction: Axis.horizontal,
                children: _selectedTags.values.toList(),
                spacing: 8,
              ) : Text(" Appuyer sur un tag pour le supprimer", 
                style: TextStyle(
                  color: GlobalsColor.darkGreen.withOpacity(0.5),
                  fontSize: 17,
                ),
              ),
            ),
          ),
        ),
        Container(
          transform: Matrix4.translationValues(0, -15, 0),
          child: TextField(
            controller: _addTagController,
            buildCounter: null,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            cursorColor: GlobalsColor.darkGreenDisabled,
            focusNode: _addTagFocusNode,
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: GlobalsColor.darkGreen,
              fontSize: 17,
            ),
            decoration: InputDecoration(
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 5),
              hintText: "Entrez un ou plusieurs tag à ajouter",
            ),
            onSubmitted: (String text) {
              //Si ya du texte
              if (text.length > 0)
                _selectedTags[text] = buildTagChipInput(text);

              _addTagController.clear();
              _addTagFocusNode.unfocus();
              setState(() {
                for (var key in _selectedTags.keys) {
                  //Si le tag existe pas déjà ont l'ajoute
                  if (!_ownGenreList.keys.contains(key))
                    _ownGenreList[key] = _selectedTags[key];
                }
              });
            },
            onChanged: (String text) {
              if (text.contains(" ")) {
                _addTagController.clear();
                text = text.replaceAll(' ', '');
                if (text.length > 0 && !_selectedTags.keys.contains(text)) {
                  setState(() {
                    _selectedTags[text] = buildTagChipInput(text);
                  });
                }
              }
            },
          ),
        ),
      ],
    );
  }


  Widget buildTrailer(Map data, BuildContext context) {
    if (data["site"] != "YouTube") return Padding(padding: EdgeInsets.zero);
    return Padding(
      padding: const EdgeInsets.only(left: 75, right: 75, bottom: 30, top: 10),
      child: ActionChip(
        avatar: CircleAvatar(
          child: Icon(CommunityMaterialIcons.youtube, color: GlobalsColor.darkGreen, size: 25,),
          backgroundColor: Colors.transparent,
        ),
        label: Text("Trailer du film", style: TextStyle(fontSize: 20)), 
        labelStyle: TextStyle(color: GlobalsColor.darkGreen, fontWeight: FontWeight.w600),
        onPressed: () {
          launch("https://youtube.com/watch?v="+data["key"]);
          print(data["key"]);
        },
      ),
    );
  }

  Widget buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10, top: 5),
      child: Divider(
        color: GlobalsColor.darkGreen,
        height: 2,
        thickness: 2,
      ),
    );
  }

  Widget buildTitle(String text) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: <BoxShadow>[BoxShadow(
            color: Colors.grey,
            spreadRadius: -1,
            blurRadius: 2,
            offset: Offset(0, 1.5)
          )],
          color: Colors.white,
        ),
        transform: Matrix4.translationValues(0, -13, 0),
        padding: EdgeInsets.all(5),
        child: Text(text,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15
          ),
        ),
      ),
    );
  }
  Wrap buildSkeletonTags(int length) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      spacing: 8,
      runSpacing: 0,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: List<Widget>.generate(length, (int index) {
        return SkeletonAnimation(
          child: Chip(
            padding: EdgeInsets.all(0),
            labelPadding: EdgeInsets.all(0),
            backgroundColor: Colors.transparent,
            shadowColor: GlobalsColor.darkGreenDisabled,
            label: Container(width: 100, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.all(Radius.circular(50))))
          )
        );
      }),
    ); 
  }

  Widget buildSkeletonCarrousel() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: List.generate(10, (int index) {
            return Card(
              elevation: 1,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                children: <Widget>[
                  SkeletonAnimation(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5), 
                        color: Colors.grey[300],
                      ),
                      width: 100,
                      height: 150,
                    ),
                  ),
                  SkeletonAnimation(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      width: 50, 
                      height: 13,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    )
                  ),
                ],
              ),
            );
          })
        ),
      ),
    );
  }
  
  void getTagList() async {
    _genreList = await TMDBQueries.getTagList();
    setState(() {
      _dispGenreList = true;
    });
  }

  void getInfoList() async {
    Map data = await TMDBQueries.getMovie(_preLoadData["id"].toString());
    _infosMap = {
      "release_date": DateFormat('dd/MM/yyyy').format(DateTime.parse(_preLoadData["release_date"])),
      "vote_average": _preLoadData["vote_average"].toString() + " ★",
      "budget": data["budget"].toString() + " \$",
      "status": data["status"],
      "language": data["spoken_languages"].length != 0 ? data["spoken_languages"][0]["name"] : null,  
    };
    setState(() {
      _dispInfoList = true;
    });
  }

  void getMovieCredits() async {
    _creditsMap = await TMDBQueries.getMovieCredits(_preLoadData["id"].toString());
    setState(() {
      _dispCredits = true;
    });
  }
  void getMovieSimilar() async {
    _similarMap = await TMDBQueries.getMovieSimilar(_preLoadData["id"].toString());
    setState(() {
      _dispSimilar = true;
    });
  }
  void getMovieTrailer() async {
    _trailerMap = await TMDBQueries.getMovieTrailer(_preLoadData["id"].toString());
    setState(() {
      _dispMovieTrailer = true;
    });
  }


  @override
  Widget build(BuildContext context) {
    String heroTag = "";
    heroTag = GlobalsArgs.transfertArg[1];
    GlobalsData.endSortBarPos = MediaQuery.of(context).padding.top;

    //Handle tag keyboard down    
    _forceHideTag = !_keyboardIsVisible();
    Future.delayed(Duration(milliseconds: 200), () async {
      _forceHideTag = false;
    });
    if (!_keyboardIsVisible() && _addTagFocusNode.hasFocus) {    
      setState(() {
        _addTagFocusNode.unfocus();
      });
    }

    return Scaffold(
      floatingActionButton: SpeedDial(
        animationSpeed: 200,
        backgroundColor: GlobalsMessage.chipData[1]["color"],
        elevation: 3,
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          color: Colors.white,
          size: 25,
          progress: _menuAnimationController,
        ),
        overlayOpacity: 0.75,
        onOpen: () {
          _menuAnimationController.forward();
        },
        onClose: () {
          _menuAnimationController.reverse();
        },
        curve: Curves.ease,
        overlayColor: Colors.transparent,
        visible: _addTagFocusNode.hasFocus ? false : true,
        children: <SpeedDialChild>[
          SpeedDialChild(
            backgroundColor: Colors.white,
            child: Icon(CommunityMaterialIcons.eye_outline, color: GlobalsColor.darkGreen, size: 24),
            onTap: () {},
            label: "Ajouter aux films vus",
            labelStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700),
          ),
          SpeedDialChild(
            backgroundColor: Colors.white,
            child: Icon(CommunityMaterialIcons.plus_box_outline, color: GlobalsColor.darkGreen, size: 24),
            onTap: () {},
            label: "Ajouter aux films à voir",
            labelStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700),
          ),
          SpeedDialChild(
            backgroundColor: Colors.white,
            child: Icon(Icons.favorite_border, color: GlobalsColor.darkGreen, size: 24),
            onTap: () {},
            label: "Ajouter aux favoris",
            labelStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700),
          ),
        ],
      ),
      body: Stack(
        overflow: Overflow.visible,
        fit: StackFit.expand,
        children: <Widget>[
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                forceElevated: true,
                backgroundColor: GlobalsColor.darkGreen,
                pinned: true,
                snap: false,
                floating: false,
                stretchTriggerOffset: 70,
                onStretchTrigger: () async => Navigator.pop(context),
                stretch: true,
                expandedHeight: _preLoadData["backdrop_path"] != null ? 175 + GlobalsData.endSortBarPos : kToolbarHeight,
                elevation: 3,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back,
                    color: _preLoadData["backdrop_path"] != null ? GlobalsMessage.chipData[1]["color"] : Colors.white,
                    size: 38,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(_preLoadData["title"] != null ? _preLoadData["title"] : _preLoadData["original_title"],
                  style: TextStyle(color: Colors.white),
                ),                
                flexibleSpace: _preLoadData["backdrop_path"] != null ? BackgroundFlexibleSpaceBar(
                  title: Text(""),
                  collapseMode: CollapseMode.parallax,
                  background: ProgressiveImage(
                    placeholder: AssetImage("assets/loading.png"),
                    thumbnail: NetworkImage(GlobalsData.thumbBackdropSize + _preLoadData["backdrop_path"], scale: 1),
                    image: NetworkImage(GlobalsData.backdropSize + _preLoadData["backdrop_path"], scale: 1),
                    width: MediaQuery.of(context).size.width,
                    height: 175 + GlobalsData.endSortBarPos + kToolbarHeight,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    fadeDuration: Duration(milliseconds: 150),
                    blur: 4,
                    repeat: ImageRepeat.noRepeat,
                    matchTextDirection: true,
                  ),
                ) : null,
              ),
              SliverList( 
                delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10, bottom: 0),
                      child: DropCapText(
                        _preLoadData["overview"] != null ? _preLoadData["overview"] : "",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                        dropCapPadding: EdgeInsets.only(right: 15),
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.fade,
                        dropCap: DropCap(
                          height: 240, 
                          width: 160,
                          child: Card(
                            elevation: 3,
                            margin: EdgeInsets.only(bottom: 0),
                            child: Hero( 
                              tag: heroTag,
                              child: ProgressiveImage(
                                placeholder: AssetImage("assets/loading.png"),
                                thumbnail: NetworkImage(GlobalsData.thumbImgSize + _preLoadData["poster_path"], scale: 1),
                                image: NetworkImage(GlobalsData.imgSize + _preLoadData["poster_path"], scale: 1),
                                width: 160,
                                height: 240,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 20,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(top: 0),
                      transform: Matrix4.translationValues(0, -5, 0),
                      child: Theme(
                        data: Theme.of(context).copyWith(splashColor: GlobalsMessage.chipData[1]["splash_color"]),
                        child: AnimatedCrossFade(
                          firstChild: buildSkeletonTags(_preLoadData["genre_ids"].length + 1),
                          secondChild: _dispGenreList ? buildGenreTags() : Padding(padding: EdgeInsets.all(0)),
                          crossFadeState: _dispGenreList ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                          duration: Duration(milliseconds: 200),
                        ),
                      ),
                    ),
                    buildDivider(),
                    Container(
                      width: MediaQuery.of(context).size.width - 20,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(top: 0),
                      child: Theme(
                        data: Theme.of(context).copyWith(splashColor: GlobalsMessage.chipData[1]["splash_color"]),
                        child: AnimatedSwitcher(
                          child: !_dispInfoList ? buildSkeletonTags(5) : buildInfoTags(),
                          duration: Duration(milliseconds: 200),
                        ),
                      ),
                    ),
                    buildDivider(),
                    buildTitle("Casting"),
                    Container(
                      width: MediaQuery.of(context).size.width - 20,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(top: 0),
                      child: Theme(
                        data: Theme.of(context).copyWith(splashColor: GlobalsMessage.chipData[1]["splash_color"]),
                        child: AnimatedSwitcher(
                          child: !_dispCredits ? buildSkeletonCarrousel() : buildCaroussel(_creditsMap["cast"], QueryTypes.person),
                          duration: Duration(milliseconds: 200),
                        ),
                      ),
                    ),
                    buildDivider(),
                    buildTitle("Équipe"),
                    Container(
                      width: MediaQuery.of(context).size.width - 20,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(top: 0),
                      child: Theme(
                        data: Theme.of(context).copyWith(splashColor: GlobalsMessage.chipData[1]["splash_color"]),
                        child: AnimatedSwitcher(
                          child: !_dispCredits ? buildSkeletonCarrousel() : buildCaroussel(_creditsMap["crew"], QueryTypes.person),
                          duration: Duration(milliseconds: 200),
                        ),
                      ),
                    ),
                    buildDivider(),
                    buildTitle("Similaire"),
                    Container(
                      width: MediaQuery.of(context).size.width - 20,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(top: 0),
                      child: Theme(
                        data: Theme.of(context).copyWith(splashColor: GlobalsMessage.chipData[1]["splash_color"]),
                        child: AnimatedSwitcher(
                          child: !_dispSimilar ? buildSkeletonCarrousel() : buildCaroussel(_similarMap["results"], QueryTypes.movie),
                          duration: Duration(milliseconds: 200),
                        ),
                      ),
                    ),
                    buildDivider(),
                    _dispMovieTrailer ? Center(
                      child: Theme(
                        data: Theme.of(context).copyWith(splashColor: GlobalsMessage.chipData[1]["splash_color"]),
                        child: buildTrailer(_trailerMap["results"][0], context),
                      ),
                    ) : Padding(padding: EdgeInsets.zero),
                  ]
                ),
              ),
            ],
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: _addTagFocusNode.hasFocus && !_forceHideTag ? InkWell(
              onTap: () => _addTagFocusNode.unfocus(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black.withOpacity(0.5),
              ),
            ) : null,
          ),
          AnimatedPositioned(
            width: MediaQuery.of(context).size.width,
            height: 100,
            bottom: _addTagFocusNode.hasFocus && !_forceHideTag ? 0 : -100,
            left: 0,
            duration: Duration(milliseconds: 200),
            child: Container(
              child: buildTagInput(), 
              height: 100,
              width: MediaQuery.of(context).size.width,
              // clipBehavior: Clip.none,
              padding: EdgeInsets.symmetric(horizontal: 16),
                // color: Colors.blue,
              decoration: BoxDecoration(
                color: GlobalsColor.plainDarkGreenDisabled,
                shape: BoxShape.rectangle,
              ),
            ),
          ),
        ]
      ),
    );
  }
}