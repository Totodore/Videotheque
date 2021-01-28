import 'package:Videotheque/Globals.dart';
import 'package:Videotheque/models/api/ApiSearchPersonModel.dart';
import 'package:Videotheque/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';

class PersonImgComponent extends StatelessWidget {

  final ApiSearchPersonModel data;
  final String heroTag;
  final Function onClick;
  final int index;
  final int elIndex = 3;

  const PersonImgComponent(this.data, this.heroTag, this.onClick, this.index);

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
        Hero(
          tag: heroTag,
          child: ProgressiveImage(
            placeholder: AssetImage("assets/img/loading.png"),
            thumbnail: Utils.fetchImage(data.profile_path, ImageTypes.Poster,true),
            image: Utils.fetchImage(data.profile_path, ImageTypes.Poster),
            width: 400,
            height: 600,
            fit: BoxFit.fitHeight,
            fadeDuration: const Duration(milliseconds: 150),
            blur: 2,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          height: data.name != null ? 40 : 0,
          child: Container(
            alignment: Alignment.center,
            child: Text(
              data.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17
              ),
              maxLines: 1
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: FractionalOffset.bottomCenter,
                  end: FractionalOffset.topCenter,
                  colors: [
                    Colors.black.withAlpha(160),
                    Colors.black.withAlpha(0)
                  ]
                )
              ),
            ),
          ),
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
}