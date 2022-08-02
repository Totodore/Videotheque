import 'package:Videotheque/globals.dart';
import 'package:Videotheque/models/api/api_search_movie_model.dart';
import 'package:Videotheque/models/api/api_search_person_model.dart';
import 'package:Videotheque/models/api/api_search_tv_model.dart';
import 'package:Videotheque/utils/utils.dart';
import 'package:Videotheque/views/search/components/cards/known_for_movie_component.dart';
import 'package:Videotheque/views/search/components/cards/known_for_tv_component.dart';
import 'package:Videotheque/views/person/person_view.dart';
import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';

class PersonCardComponent extends StatelessWidget {
  final ApiSearchPersonModel data;
  final Function onClick;
  final Function onKnownClick;
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
        onTap: () => onClick("person", index, heroTag),
        onDoubleTap: null,
        onLongPress: null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.people, color: PersonView.baseColor),
              title: Text(data.name ?? "", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
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
                    padding: data.hasImg ? EdgeInsets.only(left: 7) : EdgeInsets.zero,
                  ),
                  (data.known_for?.length ?? 0) > 0 ? Expanded(
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 0,
                      runAlignment: WrapAlignment.spaceEvenly,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.spaceEvenly,
                      children: data.known_for.map<Widget>(
                        (el) => el?.media_type == "movie" ?
                          KnownForMovieComponent(el.getAs<ApiSearchMovieModel>(), onKnownClick, index)
                        : KnownForTvComponent(el.getAs<ApiSearchTvModel>(), onKnownClick, index)
                      ).toList()
                    )
                  ) : Container(),
                ],
              ),
            ),
            Divider(
              color: PersonView.baseColor,
              height: 2,
              thickness: 2,
            ),
          ],
        ),
      ),
    );
  }
}