import 'package:Videotheque/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:progressive_image/progressive_image.dart';

class TvView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TvViewState();
  }
}

class TvViewState extends State<TvView> {

  Map _preLoadData = Map();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    String heroTag = "";

    if (GlobalsArgs.actualRoute == "/element/tv/") {
      _preLoadData = GlobalsArgs.transfertArg[0];
      heroTag = GlobalsArgs.transfertArg[1];
    } else {
      GlobalsFunc.snackBar(context);
    }



    return SafeArea(
      child: Material( 
        child: CustomScrollView(
          anchor: 0,
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            SliverPersistentHeader(
              delegate: CustomSliverAppBar(
                expandedHeight: 175, 
                heroTag: heroTag,
                banierePath: _preLoadData["backdrop_path"],
                posterPath: _preLoadData["poster_path"],
                movieTitle: _preLoadData["name"] != null ? _preLoadData["name"] : _preLoadData["original_name"] 
              ),
              pinned: true,
            ),
          ],
        ),
      )
    );
  }
}

class CustomSliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final String heroTag;
  final String posterPath;
  final String banierePath;
  final String movieTitle;

  CustomSliverAppBar({@required this.expandedHeight, @required this.heroTag, @required this.posterPath, @required this.banierePath, @required this.movieTitle});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack( 
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: <Widget>[
        ProgressiveImage(
          placeholder: AssetImage("assets/loading.png"),
          thumbnail: NetworkImage(GlobalsData.thumbBackdropSize + banierePath, scale: 1),
          image: NetworkImage(GlobalsData.backdropSize + banierePath, scale: 1),
          width: MediaQuery.of(context).size.width,
          height: expandedHeight,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          fadeDuration: Duration(milliseconds: 150),
          blur: 4,
          repeat: ImageRepeat.noRepeat,
          matchTextDirection: true,
        ),
        Center(
          child: Opacity(
            opacity: shrinkOffset/expandedHeight,
            child: Text(movieTitle),
          ),
        ),
        Positioned(
          top: 4,
          left: 4,
          child: IconButton(
            icon: Icon(Icons.arrow_back,
              color: GlobalsColor.darkGreen,
              size: 38,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Positioned(
          top: expandedHeight / 2 - shrinkOffset,
          left: MediaQuery.of(context).size.width/2 - 80, //50 c'est la moitié de la taille de l'image qu'on défini
          child: Opacity(
            opacity: (1 - shrinkOffset/expandedHeight),
            child: Card( 
              elevation: 10,
              child: Hero( 
                tag: heroTag,
                child: ProgressiveImage(
                  placeholder: AssetImage("assets/loading.png"),
                  thumbnail: NetworkImage(GlobalsData.thumbImgSize + posterPath, scale: 1),
                  image: NetworkImage(GlobalsData.imgSize + posterPath, scale: 1),
                  width: 160,
                  height: 240,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}