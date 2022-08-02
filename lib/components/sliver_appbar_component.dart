import 'dart:ui';

import 'package:Videotheque/globals.dart';
import 'package:Videotheque/utils/utils.dart';
import 'package:background_app_bar/background_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';

class SliverAppBarComponent extends StatelessWidget {

  final Color color;
  final String backdropPath;
  final String title;
  final bool added;
  final bool isFav;
  final Function(BuildContext) favTapped;

  const SliverAppBarComponent(this.color, this.backdropPath, this.title, this.added, this.isFav, this.favTapped);

  @override
  Widget build(BuildContext context) => SliverAppBar(
    forceElevated: true,
    backgroundColor: color,
    pinned: true,
    snap: false,
    floating: false,
    stretchTriggerOffset: 80,
    stretch: false,
    expandedHeight: _hasBackdrop ? 175 + GlobalsData.endSortBarPos : kToolbarHeight,
    elevation: 3,
    leading: IconButton(
      icon: Icon(Icons.arrow_back,
        color: _hasBackdrop ? color : Colors.white,
        size: 38,
      ),
      onPressed: () => Navigator.popUntil(context, ModalRoute.withName("/")),
    ),
    title: _hasBackdrop ? ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: SizedBox(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.black.withOpacity(0.4),
          ),
          margin: EdgeInsets.zero,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Text(title ?? "",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    ) : Text(title ?? "",
      style: TextStyle(color: Colors.white),
    ),
    actions: <Widget>[
      added ? IconButton(icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.white),
        onPressed: () => favTapped(context)
      ) : Container()
    ],
    flexibleSpace: _hasBackdrop ? BackgroundFlexibleSpaceBar(
      title: Text(""),
      collapseMode: CollapseMode.parallax,
      background: ProgressiveImage(
        placeholder: AssetImage("assets/img/loading.png"),
        thumbnail: Utils.fetchImage(backdropPath, ImageTypes.Backdrop, true),
        image: Utils.fetchImage(backdropPath, ImageTypes.Backdrop),
        width: MediaQuery.of(context).size.width,
        height: 175 + GlobalsData.endSortBarPos + kToolbarHeight,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        blur: 4,
        repeat: ImageRepeat.noRepeat,
        matchTextDirection: true,
      ),
    ) : Container(),
  );

  bool get _hasBackdrop => backdropPath?.isNotEmpty ?? false;
}