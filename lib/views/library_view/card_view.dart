import 'package:Videotheque/controllers/library_controller/card_controller.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/utils/utils.dart';
import 'package:Videotheque/views/tv_view/tv_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CardView extends StatelessWidget {
  QueryTypes elementType;
  Map data;
  CardView(this.elementType, this.data);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CardController(context, elementType, data),
      child: Consumer<CardController>(
        builder: (context, controller, child) {
          int indexType = QueryTypes.values.indexOf(elementType);
          String heroTag = Uuid().v1();
          Widget infos = Container();
          switch (elementType) {
            case QueryTypes.movie: 
              infos = data["overview"] != null ? Flexible(
                child: Text(data["overview"],
                  textWidthBasis: TextWidthBasis.parent,
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.fade,
                  maxLines: 10,
                  softWrap: true,
                ),
              ) : Container();
              break;
            case QueryTypes.tv:
              infos = data["overview"] != null ? Flexible(
                child: Text(data["overview"],
                  textWidthBasis: TextWidthBasis.parent,
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.fade,
                  maxLines: 10,
                  softWrap: true,
                ),
              ) : Container();
              break;
            case QueryTypes.person:
              infos = data["known_for"] != null ? Expanded(
                child: Wrap(
                  spacing: 5,
                  runSpacing: 0,
                  runAlignment: WrapAlignment.spaceEvenly,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.spaceEvenly,
                  children: List<Widget>.generate(List.from(data["known_for"]).length, (int index) {
                    Map knownForElement = Map.from(data["known_for"][index]);
                    return Theme(
                      data: Theme.of(context).copyWith(splashColor: knownForElement["media_type"] == "movie" ? GlobalsColor.darkGreenDisabled : TvView.splashColor),
                      child: ActionChip(
                        avatar: CircleAvatar(
                          child: Icon(knownForElement["media_type"] == "movie" ? Icons.movie : Icons.tv, color: knownForElement["media_type"] == "movie" ? GlobalsColor.darkGreen : TvView.baseColor),
                          backgroundColor: Colors.transparent,
                        ),
                        labelStyle: TextStyle(color: Colors.black),
                        label: Text(knownForElement["title"] != null ? knownForElement["title"] : knownForElement["name"], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        onPressed: () => controller.knownElementTapped(knownForElement["media_type"], knownForElement),
                      ),
                    );
                  })
                )
              ) : Padding(padding: EdgeInsets.all(0));
              break;
            case QueryTypes.collection:
              break;
            // case QueryTypes.companies:
            //   icon = Icons.business;
            //   posterPath = data["logo_path"];
            //   title = data["name"];
            //   break;
            default: break;
          }
          return Padding(
            padding: EdgeInsets.only(bottom: 15), 
            child: Transform(
              transform: Matrix4.translationValues(0, -6, 0),
              child: Card(
                elevation: 2,
                borderOnForeground: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                margin: EdgeInsets.all(6),
                child: InkWell(
                  onTap: () => controller.elementTapped(data, heroTag),
                  onDoubleTap: null,
                  onLongPress: null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(GlobalsMessage.chipData[indexType]["icon"], color: GlobalsMessage.chipData[indexType]["color"]),
                        title: Text(data["title"], style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 7, left: 7, bottom: 7, top:0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            data["image_url"] != null ? Hero(
                              tag: heroTag, 
                              transitionOnUserGestures: true, 
                              child: ProgressiveImage(
                                placeholder: AssetImage("assets/loading.png"),
                                thumbnail: Utils.fetchImage(data["image_url"], elementType == QueryTypes.person ? ImageTypes.Profile : ImageTypes.Poster, true),
                                image: Utils.fetchImage(data["image_url"], elementType == QueryTypes.person ? ImageTypes.Profile : ImageTypes.Poster),
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
                            infos,
                          ],
                        ),
                      ),
                      Divider(
                        color: GlobalsMessage.chipData[indexType]["color"],
                        height: 2,
                        thickness: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );  
        }
      )
    );
  }
}