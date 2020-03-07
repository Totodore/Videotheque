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
import 'package:flutter_star_rating/flutter_star_rating.dart';

class MovieView extends StatefulWidget {
  static ScrollController scrollController = ScrollController();

  @override
  State<StatefulWidget> createState() {
    return MovieViewState();
  }
}

class MovieViewState extends State<MovieView> with SingleTickerProviderStateMixin {

  Map _preLoadData = Map();
  Map _loadData = Map();
  Map _infosMap = Map();
  Map _genreList = Map();
  AnimationController _rotationAnimationController;
  bool _dispGenreList = false;
  bool _dispInfoList = false;
  BuildContext _context;

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
    super.initState();
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
    tagsChips.add(ActionChip(
      pressElevation: 3,
      elevation: 1,
      backgroundColor: Colors.transparent,
      labelStyle: TextStyle(color: GlobalsMessage.chipData[1]["color"], fontWeight: FontWeight.w600),
      labelPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 7),
      shadowColor: GlobalsColor.darkGreenDisabled,
      label: Icon(Icons.add, color: GlobalsMessage.chipData[1]["color"]),
      onPressed: () {},
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

  void getTagList() async {
    _genreList = await TMDBQueries.getTagList();
    setState(() {
      _dispGenreList = true;
    });
  }

  void getInfoList() async {
    print(_preLoadData["id"]);
    Map data = await TMDBQueries.getMovie(_preLoadData["id"].toString());
    print(data["spoken_languages"]);
    _infosMap = {
      "release_date": _preLoadData["release_date"],
      "vote_average": _preLoadData["vote_average"].toString() + " ★",
      "budget": data["budget"].toString() + " \$",
      "status": data["status"],
      "language": data["spoken_languages"].length != 0 ? data["spoken_languages"][0]["name"] : null,  
    };
    setState(() {
      _dispInfoList = true;
      print("test");
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
        overlayOpacity: 0.1,
        onOpen: () {
          _rotationAnimationController.forward();
        },
        onClose: () {
          _rotationAnimationController.reverse();
        },
        curve: Curves.ease,
        overlayColor: Colors.transparent,
        visible: true,
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


      body: CustomScrollView(
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
                ]
              ),
            ),
          ],
        ),
    );
  }
}