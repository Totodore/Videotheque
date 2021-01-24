import 'package:Videotheque/Globals.dart';
import 'package:Videotheque/models/api/ApiSearchMovieModel.dart';
import 'package:Videotheque/models/api/ApiSearchPersonModel.dart';
import 'package:Videotheque/models/api/ApiSearchTvModel.dart';
import 'package:Videotheque/utils/Utils.dart';
import 'package:Videotheque/views/search_view/components/KnownForMovieComponent.dart';
import 'package:Videotheque/views/search_view/components/KnownForTvComponent.dart';
import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';

class PersonCardComponent extends StatelessWidget {
  final ApiSearchPersonModel data;
  final Function onClick;
  final Function onKnownClick;
  final int movieIndex = 3;
  final String heroTag;
  final int index;

  PersonCardComponent(this.data, this.onClick, this.heroTag, this.onKnownClick, this.index);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      borderOnForeground: true,
      shape: RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(5))),
      margin: EdgeInsets.all(6),
      child: InkWell(
        onTap: () => onClick(GlobalsMessage.chipData[movieIndex]["route"], index, heroTag),
        onDoubleTap: null,
        onLongPress: null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.movie, color: GlobalsColor.darkGreen),
              title: Text(data.name ?? "", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
            ),
            Container(
              padding: EdgeInsets.only(right: 7, left: 7, bottom: 7, top:0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  data.profile_path != null ? Hero(
                    tag: heroTag,
                    transitionOnUserGestures: true, 
                    child: ProgressiveImage(
                      placeholder: AssetImage("assets/loading.png"),
                      thumbnail: Utils.fetchImage(data.profile_path, ImageTypes.Profile, true),
                      image: Utils.fetchImage(data.profile_path, ImageTypes.Profile),
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
                  Expanded(
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 0,
                      runAlignment: WrapAlignment.spaceEvenly,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.spaceEvenly,
                      children: data.known_for.map<Widget>(
                        (el) => el.media_type == "movie" ?
                          KnownForMovieComponent(el.getAs<ApiSearchMovieModel>(), onKnownClick, index)
                        : KnownForTvComponent(el.getAs<ApiSearchTvModel>(), onKnownClick, index)
                      ).toList()
                    )
                  ),
                ],
              ),
            ),
            Divider(
              color: GlobalsMessage.chipData[movieIndex]["color"],
              height: 2,
              thickness: 2,
            ),
          ],
        ),
      ),
    );
  }
}