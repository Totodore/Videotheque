import 'package:Videotheque/components/CrossFadeComponent.dart';
import 'package:Videotheque/components/HeaderComponent.dart';
import 'package:Videotheque/components/TrailerComponent.dart';
import 'package:Videotheque/components/divider_component.dart';
import 'package:Videotheque/components/skeleton_carrousel_component.dart';
import 'package:Videotheque/components/skeleton_tag_component.dart';

import 'package:Videotheque/controllers/tv_controller/episode_controller.dart';

import 'package:Videotheque/Globals.dart';
import 'package:Videotheque/utils/Utils.dart';

import 'package:Videotheque/views/tv_view/tag_view.dart';
import 'package:Videotheque/views/tv_view/TvView.dart';
import 'package:Videotheque/views/components/carrousel_view.dart';

import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:provider/provider.dart';

class EpisodeView extends StatelessWidget {
  Map data;
  String heroTag;
  String tvId;
  String seasonNumber;

  EpisodeView(this.data, this.heroTag, this.tvId, this.seasonNumber);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EpisodeController>(
      create: (context) => EpisodeController(context, data, heroTag, tvId, seasonNumber),
      child: Consumer<EpisodeController>(
        builder: (BuildContext context, EpisodeController controller, Widget child) {
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
                          child: HeaderComponent(controller.data["overview"], controller.heroTag, controller.data["name"], false)
                        ),
                        controller.dispElement(ElementsTypes.InfoTags) ? DividerComponent(TvView.baseColor) : Container(),
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
                        controller.dispElement(ElementsTypes.GuestsCarrousel) ? DividerComponent(TvView.baseColor, "Invités") : Container(),
                        Container(
                          width: MediaQuery.of(context).size.width - 20,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.topLeft,
                          child: Theme(
                            data: Theme.of(context).copyWith(splashColor: TvView.splashColor),
                            child: CrossFadeComponent(
                              child1: SkeletonCarrouselComponent(),
                              child2: controller.objectsStates[ElementsTypes.GuestsCarrousel] == States.Added ? CarrouselView(QueryTypes.person, controller.carrouselData[ElementsTypes.GuestsCarrousel]) : Padding(padding: EdgeInsets.all(0)),
                              dispFirst: controller.objectsStates[ElementsTypes.GuestsCarrousel] == States.Loading,
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
                            child: TrailerComponent(controller.trailerKey, "Trailer de l'épisode", TvView.baseColor),
                          ),
                        ) : Container(),
                      ]
                    ),
                  ),
                );
              }
            ),
          );
        }
      ),
    );              
  }
}