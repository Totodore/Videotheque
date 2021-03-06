import 'dart:ui';

import 'package:Videotheque/Globals.dart';
import 'package:Videotheque/models/api/ApiSearchCollectionModel.dart';
import 'package:Videotheque/utils/Utils.dart';
import 'package:Videotheque/components/NoImgComponent.dart';
import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';

class CollectionImgComponent extends StatelessWidget {

  final ApiSearchCollectionModel data;
  final String heroTag;
  final Function onClick;
  final int index;
  final int elIndex = 4;

  const CollectionImgComponent(this.data, this.heroTag, this.onClick, this.index);


  @override
  Widget build(BuildContext context) => RaisedButton(
    elevation: 2,
    clipBehavior: Clip.hardEdge,
    onPressed: () {},
    highlightElevation: 4,
    padding: EdgeInsets.zero,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    child: Stack(
      children: <Widget>[
        data.hasImg ? _getImg() : NoImgComponent(data.name),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onClick(GlobalsMessage.chipData[elIndex]["route"], index, heroTag),
              splashColor: Colors.black.withOpacity(0.2),
              highlightColor: Colors.black.withOpacity(0.1),
              child: Container(height: double.maxFinite, width: double.maxFinite),
            )
          )
        )
      ],
    ),
  );


  Widget _getImg() => ProgressiveImage(
    placeholder: AssetImage("assets/img/loading.png"),
    thumbnail: Utils.fetchImage(data.poster_path, ImageTypes.Poster,true),
    image: Utils.fetchImage(data.poster_path, ImageTypes.Poster),
    width: 400,
    height: 600,
    fit: BoxFit.fitHeight,
    fadeDuration: const Duration(milliseconds: 150),
    blur: 2,
  );
}