import 'package:Videotheque/components/cross_fade_component.dart';
import 'package:Videotheque/components/header_component.dart';
import 'package:Videotheque/components/trailer_component.dart';
import 'package:Videotheque/components/divider_component.dart';
import 'package:Videotheque/components/skeleton_carrousel_component.dart';
import 'package:Videotheque/components/skeleton_tag_component.dart';
import 'package:Videotheque/controllers/tv/tv_controller.dart';

import 'package:Videotheque/views/tv/tag_view.dart';
import 'package:Videotheque/views/tv/tv_view.dart';
import 'package:Videotheque/views/components/carrousel_view.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Videotheque/controllers/tv/season_controller.dart';
import 'package:Videotheque/globals.dart';

class SeasonView extends StatelessWidget {
  final Map data;
  final String heroTag;
  final String tvId;
  final TvController _tvController;
  
  SeasonController controller;
  SeasonView(this.data, this.heroTag, this.tvId, this._tvController);
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SeasonController>(
      create: (context) => SeasonController(context, data, heroTag, tvId, _tvController),
      child: Consumer<SeasonController>(
        builder: (BuildContext context, SeasonController controller, Widget child) {
          this.controller = controller;
          return Card(
          color: Colors.white,
          margin: EdgeInsets.zero,
          elevation: 0,
          child: SingleChildScrollView(
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
          ),
        );
        }
      )
    );
  }
}