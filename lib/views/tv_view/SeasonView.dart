import 'package:Videotheque/components/CrossFadeComponent.dart';
import 'package:Videotheque/components/HeaderComponent.dart';
import 'package:Videotheque/components/TrailerComponent.dart';
import 'package:Videotheque/components/DividerComponent.dart';
import 'package:Videotheque/components/SkeletonCarrouselComponent.dart';
import 'package:Videotheque/components/SkeletonTagComponent.dart';

import 'package:Videotheque/views/tv_view/tag_view.dart';
import 'package:Videotheque/views/tv_view/TvView.dart';
import 'package:Videotheque/views/components/CarrouselView.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Videotheque/controllers/tv_controller/season_controller.dart';
import 'package:Videotheque/Globals.dart';

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
                            child: HeaderComponent(controller.data["overview"], controller.heroTag, controller.data["poster_path"], false),
                          ),
                          controller.dispElement(ElementsTypes.InfoTags) && controller.hasImg ? DividerComponent(TvView.baseColor) : Container(),
                          Container(
                            width: MediaQuery.of(context).size.width - 20,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.topLeft,
                            child: Theme(
                              data: Theme.of(context).copyWith(splashColor: TvView.splashColor),
                              child: CrossFadeComponent(
                                child1: SkeletonTagComponent(3),
                                child2: controller.objectsStates[ElementsTypes.InfoTags] == States.Added ? TagView(ElementsTypes.InfoTags, controller.details, [], false, null) : Padding(padding: EdgeInsets.all(0)),
                                dispFirst: controller.objectsStates[ElementsTypes.InfoTags] == States.Loading,
                              ),
                            ),
                          ),
                          controller.dispElement(ElementsTypes.EpisodesCarrousel) ? DividerComponent(TvView.baseColor, "Épisodes") : Container(),
                          Container(
                            width: MediaQuery.of(context).size.width - 20,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.topLeft,
                            child: Theme(
                              data: Theme.of(context).copyWith(splashColor: TvView.splashColor),
                              child: CrossFadeComponent(
                                child1: SkeletonCarrouselComponent(),
                                child2: controller.objectsStates[ElementsTypes.EpisodesCarrousel] == States.Added ? CarrouselView(QueryTypes.tv, controller.carrouselData[ElementsTypes.EpisodesCarrousel], controller.showEpisodeEl, true) : Padding(padding: EdgeInsets.all(0)),
                                dispFirst: controller.objectsStates[ElementsTypes.EpisodesCarrousel] == States.Loading,
                              ),
                            ),
                          ),
                          controller.dispElement(ElementsTypes.CastingCarrousel) ? DividerComponent(TvView.baseColor, "Casting") : Container(),
                          Container(
                            width: MediaQuery.of(context).size.width - 20,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.topLeft,
                            child: Theme(
                              data: Theme.of(context).copyWith(splashColor: TvView.splashColor),
                              child: CrossFadeComponent(
                                child1: SkeletonCarrouselComponent(),
                                child2: controller.objectsStates[ElementsTypes.CastingCarrousel] == States.Added ? CarrouselView(QueryTypes.person, controller.carrouselData[ElementsTypes.CastingCarrousel]) : Padding(padding: EdgeInsets.all(0)),
                                dispFirst: controller.objectsStates[ElementsTypes.CastingCarrousel] == States.Loading,
                              ),
                            ),
                          ),
                          controller.dispElement(ElementsTypes.CrewCarrousel) ? DividerComponent(TvView.baseColor, "Équipe") : Container(),
                          Container(
                            width: MediaQuery.of(context).size.width - 20,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.topLeft,
                            child: Theme(
                              data: Theme.of(context).copyWith(splashColor: TvView.splashColor),
                              child: CrossFadeComponent(
                                child1: SkeletonCarrouselComponent(),
                                child2: controller.objectsStates[ElementsTypes.CrewCarrousel] == States.Added ? CarrouselView(QueryTypes.person, controller.carrouselData[ElementsTypes.CrewCarrousel]) : Padding(padding: EdgeInsets.all(0)),
                                dispFirst: controller.objectsStates[ElementsTypes.CrewCarrousel] == States.Loading,
                              ),
                            ),
                          ),
                          controller.dispElement(ElementsTypes.YoutubeTrailer) ? DividerComponent(TvView.baseColor) : Container(),
                          controller.objectsStates[ElementsTypes.YoutubeTrailer] == States.Added ? Center(
                            child: Theme(
                              data: Theme.of(context).copyWith(splashColor: TvView.splashColor),
                              child: TrailerComponent(controller.trailerKey, "Trailer de la saison", TvView.baseColor),
                            ),
                          ) : Container(),
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