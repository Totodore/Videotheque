import 'dart:ui';
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
import 'package:keyboard_visibility/keyboard_visibility.dart';

class MovieView extends StatefulWidget {
  static ScrollController scrollController = ScrollController();

  @override
  State<StatefulWidget> createState() {
    return MovieViewState();
  }
}

class MovieViewState extends State<MovieView> with SingleTickerProviderStateMixin {

  Map _preLoadData = Map();
  Map _infosMap = Map();
  Map _genreList = Map();
  Map _creditsMap = Map();
  List _ownGenreList = List();

  AnimationController _rotationAnimationController;

  List<InputChip> _selectedTags = [];
  FocusNode _addTagFocusNode = FocusNode();
  TextEditingController _addTagController = TextEditingController();
  KeyboardVisibilityNotification _keyboardVisibilityNotification = KeyboardVisibilityNotification();

  bool _dispGenreList = false;
  bool _dispInfoList = false;
  bool _dispCredits = false;

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

    getTagList();
    getInfoList();
    getMovieCredits();

    super.initState();

    _keyboardVisibilityNotification.addNewListener(
      onHide: () {
        if (_addTagFocusNode.hasFocus)
          _addTagFocusNode.unfocus();
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
        labelPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 7),
        pressElevation: 3,
        elevation: 1,
        backgroundColor: Colors.transparent,
        labelStyle: TextStyle(color: GlobalsMessage.chipData[1]["color"], fontWeight: FontWeight.w600),
        shadowColor: GlobalsColor.darkGreenDisabled,
        avatar: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(Icons.label_outline, color: GlobalsMessage.chipData[1]["color"]),
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
      pressElevation: 3,
      elevation: 1,
      backgroundColor: Colors.transparent,
      labelStyle: TextStyle(color: GlobalsMessage.chipData[1]["color"], fontWeight: FontWeight.w600),
      labelPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 7),
      shadowColor: GlobalsColor.darkGreenDisabled,
      label: Icon(Icons.add, color: GlobalsMessage.chipData[1]["color"]),
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
          labelPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 7),
          pressElevation: 3,
          elevation: 1,
          backgroundColor: Colors.transparent,
          labelStyle: TextStyle(color: GlobalsMessage.chipData[1]["color"], fontWeight: FontWeight.w600),
          shadowColor: GlobalsColor.darkGreenDisabled,
          avatar: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(Icons.info_outline, color: GlobalsMessage.chipData[1]["color"]),
          ),
          onPressed: () {},
        );
      }),
    );
  }

  Widget buildCredits(data) {
    String subTitle;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: List.generate(data.length, (int index) {
          if (data[index]["character"] != null)
            subTitle = data[index]["character"];
          else if (data[index]["deparment"] != null)
            subTitle = data[index]["deparment"];
          else
          subTitle = "";
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              children: <Widget>[
                data[index]["profile_path"] != null ? ProgressiveImage(
                  placeholder: AssetImage("assets/loading.png"),
                  thumbnail: NetworkImage(GlobalsData.thumbImgSize + data[index]["profile_path"], scale: 1),
                  image: NetworkImage(GlobalsData.imgSize + data[index]["profile_path"], scale: 1),
                  width: 100,
                  height: 150,
                  fit: BoxFit.cover,
                  fadeDuration: Duration(milliseconds: 150),
                  blur: 2,
                ) : Padding(padding: EdgeInsets.zero),
                Text(data[index]["name"]),
                Text(subTitle)
              ],
            ),
          );
        })
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
            elevation: 1,
            backgroundColor: Colors.transparent,
            shadowColor: GlobalsColor.darkGreenDisabled,
            label: Container(width: 100, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.all(Radius.circular(50))))
          )
        );
      }),
    ); 
  }

  Widget buildSkeletonCarrousel() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: List.generate(10, (int index) {
        return Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: <Widget>[
              SkeletonAnimation(
                child: Container(
                  width: 100,
                  height: 150,
                  color: Colors.grey[300],
                ),
              ),
              SkeletonAnimation(
                child: Container(
                  width: 50, 
                  height: 13,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                )
              ),
              SkeletonAnimation(
                child: Container(
                  width: 50, 
                  height: 13,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                )
              )
            ],
          ),
        );
      })
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

  Widget buildTagChipInput(String tag) {
    return InputChip(
      label: Text(tag),
      labelPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 7),
      pressElevation: 3,
      elevation: 1,
      backgroundColor: Colors.transparent,
      labelStyle: TextStyle(color: GlobalsMessage.chipData[1]["color"], fontWeight: FontWeight.w600),
      shadowColor: GlobalsColor.darkGreenDisabled,
      avatar: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(Icons.close, color: GlobalsMessage.chipData[1]["color"]),
      ),
      onPressed: () {
        print(this);
        setState(() {
          _selectedTags.removeAt(_selectedTags.length-1);
        });
      },
    );
  }

  Widget buildTagInput() {
    return TextField(
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
        // contentPadding: EdgeInsets.only(left: 5),
        prefixIcon: _selectedTags != null ? Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Wrap(
            children: _selectedTags,
            spacing: 8,
          ),
        ) : null,
      ),
      onSubmitted: (String text) {
        if (text.length > 0)
          _selectedTags.add(buildTagChipInput(text));
        _addTagController.clear();
        _addTagFocusNode.unfocus();
        setState(() {
          for (var element in _selectedTags) {
            if (!_ownGenreList.contains(element))
              _ownGenreList.add(element);
          }
          _selectedTags = [];        
        });
      },
      onChanged: (String text) {
        if (_selectedTags.length == 3) {
          _addTagController.clear();
        }
        else if (text.contains(" ")) {
          _addTagController.clear();
          setState(() {
            String tag = text.split(" ")[0];
            _selectedTags.add(buildTagChipInput(tag));
          });
        }
      },
    );
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

              SliverFillRemaining(
                hasScrollBody: true,
                fillOverscroll: false,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
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
                            child: !_dispCredits ? buildSkeletonCarrousel() : buildCredits(_creditsMap["cast"]),
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
                            child: !_dispCredits ? buildSkeletonCarrousel() : buildCredits(_creditsMap["crew"]),
                            duration: Duration(milliseconds: 200),
                          ),
                        ),
                      ),
                    ]
                  ),
              ),
            ],
          ),
          AnimatedPositioned(
            width: MediaQuery.of(context).size.width,
            height: 50,
            bottom: _addTagFocusNode.hasFocus ? 0 : -50,
            left: 0,
            duration: Duration(milliseconds: 200),
            child: Container(
              child: buildTagInput(), 
              height: 50,
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