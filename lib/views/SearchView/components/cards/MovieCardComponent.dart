import 'package:Videotheque/Globals.dart';
import 'package:Videotheque/models/api/ApiSearchMovieModel.dart';
import 'package:Videotheque/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';

class MovieCardComponent extends StatelessWidget {
  final ApiSearchMovieModel data;
  final Function onClick;
  final String heroTag;
  final int index;

  MovieCardComponent(this.data, this.onClick, this.heroTag, this.index);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      borderOnForeground: true,
      shape: RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(5))),
      margin: EdgeInsets.all(6),
      child: InkWell(
        onTap: () => onClick("movie", index, heroTag),
        onDoubleTap: null,
        onLongPress: null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.movie, color: GlobalsColor.darkGreen),
              title: Text(data.title ?? data.original_title ?? "", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            ),
            Container(
              padding: EdgeInsets.only(right: 7, left: 7, bottom: data.hasBody ? 7 : 0, top:0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  data.hasImg ? Hero(
                    tag: heroTag,
                    transitionOnUserGestures: true, 
                    child: ProgressiveImage(
                      placeholder: AssetImage("assets/img/loading.png"),
                      thumbnail: Utils.fetchImage(data.poster_path, ImageTypes.Poster, true),
                      image: Utils.fetchImage(data.poster_path, ImageTypes.Poster),
                      width: 100,
                      height: 150,
                      fit: BoxFit.cover,
                      fadeDuration: Duration(milliseconds: 150),
                      blur: 2,
                    )
                  ) : Container(),
                  Padding(
                    padding: data.hasImg ? EdgeInsets.only(left: 7) : EdgeInsets.zero,
                  ),
                  (data.overview?.length ?? 0) > 0 ? Flexible(
                    child: Text(data.overview ?? "",
                      textWidthBasis: TextWidthBasis.parent,
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.fade,
                      maxLines: 10,
                      softWrap: true,
                    ),
                  ) : Container()
                ],
              ),
            ),
            Divider(
              color: GlobalsColor.darkGreen,
              height: 2,
              thickness: 2,
            ),
          ],
        ),
      ),
    );
  }
}