import 'package:Videotheque/Globals.dart';
import 'package:Videotheque/utils/Utils.dart';
import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';

class HeaderComponent extends StatelessWidget {

  final String overview;
  final String heroTag;
  final String poster;
  final bool isProfile;

  const HeaderComponent(this.overview, this.heroTag, this.poster, this.isProfile);

  @override
  Widget build(BuildContext context) {
    if (_hasOverview && _hasPoster)
      return _fullHeader();
    else if (_hasOverview)
      return _textHeader();
    else if (_hasPoster)
      return _posterHeader();
    else return Container();
  }

  Widget _fullHeader() => DropCapText(
    overview,
    style: TextStyle(
      fontSize: 17,
      height: 1.4
    ),
    dropCapPadding: EdgeInsets.only(right: 15),
    textAlign: TextAlign.justify,
    overflow: TextOverflow.fade,
    dropCap: DropCap(
      height: 240, 
      width: 160,
      child: _posterCard()
    ),
  );

  Widget _posterHeader() => Container(
    alignment: Alignment.centerLeft,
    child: Container(
      width: 160,
      padding: EdgeInsets.only(bottom: 15),
      child: _posterCard()
    ),
  );

  Widget _textHeader() => Text(overview,
    style: TextStyle(
      fontSize: 17,
      height: 1.4
    ),
    textAlign: TextAlign.justify,
    overflow: TextOverflow.fade
  );

  Widget _posterCard() => Card(
    elevation: 3,
    margin: EdgeInsets.only(bottom: 0),
    child: Hero(
      tag: heroTag,
      child: ProgressiveImage(
        placeholder: AssetImage("assets/img/loading.png"),
        thumbnail: Utils.fetchImage(poster, isProfile ? ImageTypes.Profile : ImageTypes.Poster, true),
        image: Utils.fetchImage(poster, isProfile ? ImageTypes.Profile : ImageTypes.Poster),
        width: 160,
        height: 240,
        fit: BoxFit.cover,
      ),
    ),
  );

  bool get _hasOverview => overview?.isNotEmpty ?? false;
  bool get _hasPoster => poster?.isNotEmpty ?? false;
}