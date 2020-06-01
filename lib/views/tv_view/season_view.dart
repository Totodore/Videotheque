import 'package:Videotheque/components/divider_component.dart';
import 'package:Videotheque/components/skeleton_carrousel_component.dart';
import 'package:Videotheque/components/skeleton_tag_component.dart';

import 'package:Videotheque/views/tv_view/tag_view.dart';
import 'package:Videotheque/views/tv_view/trailer_view.dart';
import 'package:Videotheque/views/tv_view/tv_view.dart';
import 'package:Videotheque/views/components/carrousel_view.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:progressive_image/progressive_image.dart';

import 'package:Videotheque/controllers/tv_controller/season_controller.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/utils.dart';

class SeasonView extends StatelessWidget {
  Map data;
  String heroTag;
  String tvId;
  SeasonView(this.data, this.heroTag, this.tvId);
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SeasonController>(
      create: (context) => SeasonController(context, data, heroTag, tvId),
      child: Consumer<SeasonController>(
        builder: (BuildContext context, SeasonController controller, Widget child) {
          return Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
            child: DraggableScrollableSheet(
              initialChildSize: 1 - (kToolbarHeight+MediaQuery.of(context).padding.top)/MediaQuery.of(context).size.height - 0.04,
              maxChildSize: 1 - (kToolbarHeight+MediaQuery.of(context).padding.top)/MediaQuery.of(context).size.height - 0.04,
              minChildSize: 0.7,
              builder: (BuildContext context, ScrollController scrollController) {
                return Container(
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                    ]
                  ),          
                  child: SingleChildScrollView(
                    controller: scrollController,
                    physics: BouncingScrollPhysics(),
                    child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: DividerComponent(TvView.baseColor, controller.data["name"]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10, top: 0, bottom: 0),
                            child: controller.data["overview"] != null && controller.data["overview"].length > 2 ? DropCapText(
                              controller.data["overview"],
                              style: TextStyle(
                                fontSize: 17,
                              ),
                              dropCapPadding: EdgeInsets.only(right: 15),
                              textAlign: TextAlign.justify,
                              overflow: TextOverflow.fade,
                              dropCap: DropCap(
                                height: 240, 
                                width: 160,
                                child: Card(
                                  elevation: 3,
                                  margin: EdgeInsets.only(bottom: 0),
                                  child: Hero(
                                    tag: controller.heroTag,
                                    child: ProgressiveImage(
                                      placeholder: AssetImage("assets/loading.png"),
                                      thumbnail: Utils.fetchImage(controller.data["poster_path"], ImageTypes.Poster, true),
                                      image: Utils.fetchImage(controller.data["poster_path"],  ImageTypes.Poster),
                                      width: 160,
                                      height: 240,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ) : Container(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 160,
                                padding: EdgeInsets.only(bottom: 15),
                                child: Card(
                                  elevation: 3,
                                  margin: EdgeInsets.only(bottom: 0),
                                  child: Hero(
                                    tag: controller.heroTag,
                                    child: ProgressiveImage(
                                      placeholder: AssetImage("assets/loading.png"),
                                      thumbnail: Utils.fetchImage(controller.data["poster_path"], ImageTypes.Poster, true),
                                      image: Utils.fetchImage(controller.data["poster_path"], ImageTypes.Poster),
                                      width: 160,
                                      height: 240,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          controller.dispElement(ElementsTypes.InfoTags) ? DividerComponent(TvView.baseColor) : Padding(padding: EdgeInsets.zero),
                          Container(
                            width: MediaQuery.of(context).size.width - 20,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.topLeft,
                            child: Theme(
                              data: Theme.of(context).copyWith(splashColor: TvView.splashColor),
                              child: AnimatedCrossFade(
                                firstChild: SkeletonTagComponent(3),
                                secondChild: controller.objectsStates[ElementsTypes.InfoTags] == States.Added ? TagView(ElementsTypes.InfoTags, controller.details, [], false, null) : Padding(padding: EdgeInsets.all(0)),
                                crossFadeState: controller.objectsStates[ElementsTypes.InfoTags] != States.Loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                duration: Duration(milliseconds: 200),
                              ),
                            ),
                          ),
                          controller.dispElement(ElementsTypes.EpisodesCarrousel) ? DividerComponent(TvView.baseColor, "Épisodes") : Padding(padding: EdgeInsets.zero),
                          Container(
                            width: MediaQuery.of(context).size.width - 20,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.topLeft,
                            child: Theme(
                              data: Theme.of(context).copyWith(splashColor: TvView.splashColor),
                              child: AnimatedCrossFade(
                                firstChild: SkeletonCarrouselComponent(),
                                secondChild: controller.objectsStates[ElementsTypes.EpisodesCarrousel] == States.Added ? CarrouselView(QueryTypes.tv, controller.carrouselData[ElementsTypes.EpisodesCarrousel], controller.showEpisodeEl) : Padding(padding: EdgeInsets.all(0)),
                                crossFadeState: controller.objectsStates[ElementsTypes.EpisodesCarrousel] != States.Loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                duration: Duration(milliseconds: 200),
                              ),
                            ),
                          ),
                          controller.dispElement(ElementsTypes.CastingCarrousel) ? DividerComponent(TvView.baseColor, "Casting") : Padding(padding: EdgeInsets.zero),
                          Container(
                            width: MediaQuery.of(context).size.width - 20,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.topLeft,
                            child: Theme(
                              data: Theme.of(context).copyWith(splashColor: TvView.splashColor),
                              child: AnimatedCrossFade(
                                firstChild: SkeletonCarrouselComponent(),
                                secondChild: controller.objectsStates[ElementsTypes.CastingCarrousel] == States.Added ? CarrouselView(QueryTypes.person, controller.carrouselData[ElementsTypes.CastingCarrousel]) : Padding(padding: EdgeInsets.all(0)),
                                crossFadeState: controller.objectsStates[ElementsTypes.CastingCarrousel] != States.Loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                duration: Duration(milliseconds: 200),
                              ),
                            ),
                          ),
                          controller.dispElement(ElementsTypes.CrewCarrousel) ? DividerComponent(TvView.baseColor, "Équipe") : Padding(padding: EdgeInsets.zero),
                          Container(
                            width: MediaQuery.of(context).size.width - 20,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.topLeft,
                            child: Theme(
                              data: Theme.of(context).copyWith(splashColor: TvView.splashColor),
                              child: AnimatedCrossFade(
                                firstChild: SkeletonCarrouselComponent(),
                                secondChild: controller.objectsStates[ElementsTypes.CrewCarrousel] == States.Added ? CarrouselView(QueryTypes.person, controller.carrouselData[ElementsTypes.CrewCarrousel]) : Padding(padding: EdgeInsets.all(0)),
                                crossFadeState: controller.objectsStates[ElementsTypes.CrewCarrousel] != States.Loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                duration: Duration(milliseconds: 200),
                              ),
                            ),
                          ),
                          controller.dispElement(ElementsTypes.YoutubeTrailer) ? DividerComponent(TvView.baseColor) : Padding(padding: EdgeInsets.zero),
                          controller.objectsStates[ElementsTypes.YoutubeTrailer] == States.Added ? Center(
                            child: Theme(
                              data: Theme.of(context).copyWith(splashColor: TvView.splashColor),
                              child: TrailerView(controller.trailerKey),
                            ),
                          ) : Padding(padding: EdgeInsets.zero),  
                        ],
                      )
                  )
                );
              }
            )
          );
        }
      )
    );
  }
}