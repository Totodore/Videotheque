
import 'package:Videotheque/controllers/search_controller/result_controller.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/views/tv_view/tv_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:Videotheque/utils.dart';

class ResultSearchView extends StatelessWidget {
  QueryTypes type;
  List data;
  ResultSearchView(QueryTypes selectedType, List inputData) {
    type = selectedType;
    data = inputData;
  }
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ResultSearchController>(
      create: (context) => ResultSearchController(type, context, data),
      child: Consumer<ResultSearchController>(builder: (context, controller, child) {
        return SafeArea(
          top: false,
          bottom: false,
          child: Builder(builder: (BuildContext context) {
            return CustomScrollView(
              physics: BouncingScrollPhysics(),
              key: PageStorageKey<String>(type.toString()),
              slivers: <Widget>[
                SliverOverlapInjector(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int indexEl) {
                       //Déclaration des différents composants;
                      int indexType;
                      QueryTypes elementType;
                      Map element = Map.from(controller.data[indexEl]);
                      String title = ""; 
                      String posterPath;
                      String heroTag = Uuid().v1();
                      IconData icon;
                      Widget infos = Container();
                      
                      //Si la requête est générale on détermine le type pour chaque élément sinon
                      if (type == QueryTypes.all) {
                        for (var chipData in GlobalsMessage.chipData) {
                          if (chipData["route"] == element["media_type"]) {
                            indexType = GlobalsMessage.chipData.indexOf(chipData);
                            elementType = QueryTypes.values[GlobalsMessage.chipData.indexOf(chipData)];
                            break;
                          }
                        }
                      } else {
                        elementType = type;
                        indexType = QueryTypes.values.indexOf(type);
                      }  //Si la requête est spécifique on connait déjà le type
                      Color iconColor = GlobalsMessage.chipData[indexType]["color"];
                      switch (elementType) {
                        case QueryTypes.movie: 
                          icon = Icons.movie;
                          posterPath = element["poster_path"];
                          title = element["title"] != null ? element["original_title"] : null;
                          infos = element["overview"] != null ? Flexible(
                            child: Text(element["overview"],
                              textWidthBasis: TextWidthBasis.parent,
                              textAlign: TextAlign.justify,
                              overflow: TextOverflow.fade,
                              maxLines: 10,
                              softWrap: true,
                            ),
                          ) : Container();
                          break;
                        case QueryTypes.tv:
                          icon = Icons.tv;
                          posterPath = element["poster_path"];
                          title = element["name"] != null ? element["original_name"] : null;
                          infos = element["overview"] != null ? Flexible(
                            child: Text(element["overview"],
                              textWidthBasis: TextWidthBasis.parent,
                              textAlign: TextAlign.justify,
                              overflow: TextOverflow.fade,
                              maxLines: 10,
                              softWrap: true,
                            ),
                          ) : Container();
                          break;
                        case QueryTypes.person:
                          icon = Icons.person;
                          posterPath = element["profile_path"];
                          title = element["name"];
                          infos = element["known_for"] != null ? Expanded(
                            child: Wrap(
                              spacing: 5,
                              runSpacing: 0,
                              runAlignment: WrapAlignment.spaceEvenly,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.spaceEvenly,
                              children: List<Widget>.generate(List.from(element["known_for"]).length, (int index) {
                                Map knownForElement = Map.from(element["known_for"][index]);
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
                          icon = Icons.subscriptions;
                          posterPath = element["poster_path"] != null ? element["poster_path"] : "";
                          title = element["name"] != null ? element["name"] : "";
                          break;
                        // case QueryTypes.companies:
                        //   icon = Icons.business;
                        //   posterPath = element["logo_path"];
                        //   title = element["name"];
                        //   break;
                        default: break;
                      }
                      return AnimationConfiguration.staggeredList(
                        position: indexEl,
                        duration: const Duration(milliseconds: 350),
                        child: SlideAnimation(
                          verticalOffset: 25,
                          child: FadeInAnimation(
                            child: Card(
                              elevation: 2,
                              borderOnForeground: true,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                              margin: EdgeInsets.all(6),
                              child: InkWell(
                                onTap: () => controller.elementTapped(GlobalsMessage.chipData[indexType]["route"], element, heroTag),
                                onDoubleTap: null,
                                onLongPress: null,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon(icon, color: iconColor),
                                      title: title != null ? Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),) : null,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(right: 7, left: 7, bottom: 7, top:0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          posterPath != null ? Hero(
                                            tag: heroTag, 
                                            transitionOnUserGestures: true, 
                                            child: ProgressiveImage(
                                              placeholder: AssetImage("assets/loading.png"),
                                              thumbnail: Utils.fetchImage(posterPath, type == QueryTypes.person ? ImageTypes.Profile : ImageTypes.Poster, true),
                                              image: Utils.fetchImage(posterPath, type == QueryTypes.person ? ImageTypes.Profile : ImageTypes.Poster),
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
                        ),
                      );
                    },
                    childCount: controller.data.length,
                  ),
                  // itemExtent: 300,
                )
              ],
            );
          }),
        );
      })
    );
  }
}