import 'dart:ui';
import 'package:vector_math/vector_math.dart' as vector;
import 'dart:math';

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
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieView extends StatefulWidget {
  static ScrollController scrollController = ScrollController();

  @override
  State<StatefulWidget> createState() {
    return MovieViewState();
  }
}

class MovieViewState extends State<MovieView> with TickerProviderStateMixin {

  Map _preLoadData = Map();
  Map _infosMap = Map();
  Map _genreList = Map();
  Map _creditsMap = Map();
  Map _similarMap = Map();
  Map _trailerMap = Map();
  List _ownGenreList = List();

  AnimationController _rotationAnimationController;
  AnimationController _chipShakeAnimationController;

  List<Widget> _selectedTags = [];
  FocusNode _addTagFocusNode = FocusNode();
  TextEditingController _addTagController = TextEditingController();
  KeyboardVisibilityNotification _keyboardVisibilityNotification = KeyboardVisibilityNotification();

  bool _dispGenreList = false;
  bool _dispInfoList = false;
  bool _dispCredits = false;
  bool _dispSimilar = false;
  bool _dispMovieTrailer = false;

  @override
  void initState() {
    _preLoadData = GlobalsArgs.transfertArg[0];
    _rotationAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      value: 0,
      lowerBound: 0,
      upperBound: 45 * pi/180,
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

    _keyboardVisibilityNotification.addNewListener(
      onHide: () {
        if (_addTagFocusNode.hasFocus)
          setState(() => _addTagFocusNode.unfocus());
      }
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Wrap buildGenreTags() {
    List<Widget> tagsChips = List<Widget>.generate(_preLoadData["genre_ids"].length, (int index) {
      int tagId = _preLoadData["genre_ids"][index];
      String tagName;
      for (Map element in _genreList["genres"]) {
        if (element["id"] == tagId) {
          tagName = element["name"];
          break;
        }
      }
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
    if (_ownGenreList != null) {
      for (Widget element in _ownGenreList) {
        tagsChips.add(element);
      }
    }
    tagsChips.add(ActionChip(
      labelStyle: TextStyle(color: GlobalsColor.darkGreen, fontWeight: FontWeight.w600),
      label: Icon(Icons.edit, color: GlobalsColor.darkGreen),
      onPressed: () {
        _addTagFocusNode.requestFocus();
      },
    ));
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      spacing: 8,
      runSpacing: 0,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: tagsChips,
    );
  }

  Wrap buildInfoTags() {
    return Wrap(
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
    );
  }

  Widget buildCaroussel(data, QueryTypes type) {
    var toRemove = [];

    if (type == QueryTypes.person) {
      for(var i = 0;i<data.length;i++){
        var ele = data[i];
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
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: List.generate(data.length, (int index) {
            String name;
            String img_url;

            if (data[index]["profile_path"] != null) {
              img_url = data[index]["profile_path"];
              name = data[index]["name"];
            } else if (data[index]["poster_path"] != null) {
              img_url = data[index]["poster_path"];
              name = data[index]["title"];       
            } else 
              return Padding(padding: EdgeInsets.all(0));

            return Card(
              elevation: 1,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: InkWell(
                  onTap: () {
                    
                  },
                  splashColor: GlobalsMessage.chipData[1]["splash_color"],
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                        clipBehavior: Clip.hardEdge,
                        child: ProgressiveImage(
                          placeholder: AssetImage("assets/loading.png"),
                          thumbnail: NetworkImage(GlobalsData.thumbImgSize + img_url, scale: 1),
                          image: NetworkImage(GlobalsData.imgSize + img_url, scale: 1),
                          width: 100,
                          height: 150,
                          fit: BoxFit.cover,
                          fadeDuration: Duration(milliseconds: 150),
                          blur: 2,                      
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                        child: Text(name, style: TextStyle(fontWeight: FontWeight.w700),),
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
    InputChip inputChip;
    inputChip = InputChip(
        label: Text(tag),
        labelStyle: TextStyle(color: GlobalsColor.darkGreen, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(width: 0.7, style: BorderStyle.solid, color: Colors.red)
        ),
        avatar: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(Icons.label, color: GlobalsColor.darkGreen),
        ),
        onPressed: () {
          setState(() {
            _selectedTags.remove(inputChip);
          });
        },
      );
    return PositionedTransition(
      rect: RelativeRectTween(begin: RelativeRect.fromLTRB(10, 0, 0, 0), end: RelativeRect.fromLTRB(0, 0, 10, 0)).animate(_chipShakeAnimationController),
      child: inputChip
    );
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
            child: Wrap(
              direction: Axis.horizontal,
              children: _selectedTags,
              spacing: 8,
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
                _selectedTags.add(buildTagChipInput(text));

              _addTagController.clear();
              _addTagFocusNode.unfocus();
              setState(() {
                for (var element in _selectedTags) {
                  //Si le tag existe pas déj) ont l'ajoute
                  if (!_ownGenreList.contains(element))
                    _ownGenreList.add(element);
                }
                // _selectedTags = []; //On vide selectedTags
              });
            },
            onChanged: (String text) {
              if (text.contains(" ")) {
                _addTagController.clear();
                String tag = text.split(" ")[0];
                setState(() {
                  _selectedTags.add(buildTagChipInput(tag));
                });
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
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Divider(
        color: GlobalsColor.darkGreen,
        height: 2,
        thickness: 2,
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
    return Scaffold(       
      floatingActionButton: SpeedDial(
        animationSpeed: 200,
        backgroundColor: GlobalsMessage.chipData[1]["color"],
        elevation: 3,
        child: RotationTransition(
          turns: _rotationAnimationController.drive(Tween<double>(begin: 0, end: 45 * pi/180)),
          child: Icon(Icons.add, color: Colors.white, size: 24),
        ),
        overlayOpacity: 0.2,
        onOpen: () {
          _rotationAnimationController.forward();
        },
        onClose: () {
          _rotationAnimationController.reverse();
        },
        curve: Curves.ease,
        overlayColor: Colors.transparent,
        visible: _addTagFocusNode.hasFocus ? false : true,
        children: <SpeedDialChild>[
          SpeedDialChild(
            backgroundColor: Colors.white,
            child: Icon(CommunityMaterialIcons.eye_outline, color: GlobalsColor.darkGreen, size: 24),
            onTap: () {},
          ),
          SpeedDialChild(
            backgroundColor: Colors.white,
            child: Icon(CommunityMaterialIcons.plus_box_outline, color: GlobalsColor.darkGreen, size: 24),
            onTap: () {},
          ),
          SpeedDialChild(
            backgroundColor: Colors.white,
            child: Icon(Icons.favorite_border, color: GlobalsColor.darkGreen, size: 24),
            onTap: () {},
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
                backgroundColor: Colors.transparent,
                pinned: true,
                snap: false,
                floating: false,
                stretchTriggerOffset: 70,
                onStretchTrigger: () async => Navigator.pop(context),
                stretch: true,
                expandedHeight: 175 + GlobalsData.endSortBarPos,
                elevation: 3,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back,
                    color: GlobalsMessage.chipData[1]["color"],
                    // color: Colors.white,
                    size: 38,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(_preLoadData["title"] != null ? _preLoadData["title"] : _preLoadData["original_title"],
                  // style: TextStyle(color: GlobalsMessage.chipData[1]["color"]),
                  style: TextStyle(color: Colors.white),
                ),
                
                flexibleSpace: BackgroundFlexibleSpaceBar(
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
                ),
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
                          firstChild: buildSkeletonTags(_preLoadData["genre_ids"].length),
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
                    Text("Casting"),
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
                    Text("Équipe"),
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
                    Text("Similaire"),
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
            child: _addTagFocusNode.hasFocus ? InkWell(
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
            bottom: _addTagFocusNode.hasFocus ? 0 : -100,
            left: 0,
            duration: Duration(milliseconds: 200),
            child: Container(
              child: buildTagInput(), 
              height: 100,
              width: MediaQuery.of(context).size.width,
              clipBehavior: Clip.none,
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