
import 'dart:ui';

import 'package:Videotheque/components/CrossFadeComponent.dart';
import 'package:Videotheque/components/FABComponent.dart';
import 'package:Videotheque/components/HeaderComponent.dart';
import 'package:Videotheque/components/SliverAppBarComponent.dart';
import 'package:Videotheque/components/ToSeeSeenComponent.dart';
import 'package:Videotheque/components/TrailerComponent.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Videotheque/Globals.dart';

import 'package:Videotheque/views/movie_view/tag_view.dart';
import 'package:Videotheque/views/components/carrousel_view.dart';

import 'package:Videotheque/controllers/movie_controller/movie_controller.dart';

import 'package:Videotheque/components/SkeletonCarrouselComponent.dart';
import 'package:Videotheque/components/SkeletonTagComponent.dart';
import 'package:Videotheque/components/DividerComponent.dart';

class MovieView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MovieController>(
      create: (context) => MovieController(context),
      child: Consumer<MovieController>(
        builder: (context, controller, child) {
          return Scaffold(
            floatingActionButton: FABComponent(controller.isAdded, GlobalsColor.darkGreen, controller.isAdded ? controller.removeMovie : controller.addMovie),
            body: Builder(
              builder: (context) {
                BuildContext scaffoldContext = context;
                return CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverAppBarComponent(GlobalsColor.darkGreen, controller.preloadData["backdrop_path"], controller.preloadData["title"] ?? controller.preloadData["original_title"], controller.isAdded, controller.isFav, controller.onFavTapped),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10, bottom: 0),
                          child: HeaderComponent(controller.preloadData["overview"], controller.heroTag, controller.preloadData["poster_path"], false),
                        ),
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 150),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            final Animation<Offset> animationOffset = Tween<Offset>(begin: Offset(0.0, 0.3), end: Offset(0.0, 0.0)).animate(animation);
                            return FadeTransition(child: SlideTransition(child: child, position: animationOffset), opacity: animation);
                          },
                          child: controller.isAdded ? ToSeeSeenComponent(
                            () => controller.onMovieToSeeTapped(scaffoldContext), 
                            () => controller.onMovieSeenTapped(scaffoldContext), 
                            controller.isToSee, 
                            controller.isSeen, 
                            GlobalsColor.darkGreen,
                            "Film à voir",
                            "Film vu") : Container(),
                        ),
                        controller.isAdded ? DividerComponent(GlobalsColor.darkGreen) : Container(),
                        Container(
                          width: MediaQuery.of(context).size.width - 20,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 0),
                          transform: Matrix4.translationValues(0, -5, 0),
                          child: Theme(
                            data: Theme.of(context).copyWith(splashColor: GlobalsColor.darkGreen),
                            child: CrossFadeComponent(
                              child1: SkeletonTagComponent(controller.preloadData["genre_ids"].length + 1),
                              child2: controller.objectsStates[ElementsTypes.GenreTags] == States.Added ? TagView(ElementsTypes.GenreTags, controller.loadedGenreTags, controller.addedGenreTags, controller.isAdded, controller.onAddTagTapped): Padding(padding: EdgeInsets.all(0)),
                              dispFirst: controller.objectsStates[ElementsTypes.GenreTags] == States.Loading,
                            ),
                          ),
                        ),
                        controller.dispElement(ElementsTypes.InfoTags) ? DividerComponent(GlobalsColor.darkGreen) : Container(),
                        Container(
                          width: MediaQuery.of(context).size.width - 20,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 0),
                          transform: Matrix4.translationValues(0, -5, 0),
                          child: Theme(
                            data: Theme.of(context).copyWith(splashColor: GlobalsColor.darkGreen),
                            child: CrossFadeComponent(
                              child1: SkeletonTagComponent(3),
                              child2: controller.objectsStates[ElementsTypes.InfoTags] == States.Added ? TagView(ElementsTypes.InfoTags, controller.loadedInfosTags, [], controller.isAdded, controller.onAddTagTapped) : Padding(padding: EdgeInsets.all(0)),
                              dispFirst: controller.objectsStates[ElementsTypes.InfoTags] == States.Loading,
                            ),
                          ),
                        ),
                        controller.dispElement(ElementsTypes.CastingCarrousel) ? DividerComponent(GlobalsColor.darkGreen, "Casting") : Container(),
                        Container(
                          width: MediaQuery.of(context).size.width - 20,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 0),
                          transform: Matrix4.translationValues(0, -5, 0),
                          child: Theme(
                            data: Theme.of(context).copyWith(splashColor: GlobalsColor.darkGreen),
                            child: CrossFadeComponent(
                              child1: SkeletonCarrouselComponent(),
                              child2: controller.objectsStates[ElementsTypes.CastingCarrousel] == States.Added ? CarrouselView(QueryTypes.person, controller.carrouselData[ElementsTypes.CastingCarrousel]) : Padding(padding: EdgeInsets.all(0)),
                              dispFirst: controller.objectsStates[ElementsTypes.CastingCarrousel] == States.Loading,
                            ),
                          ),
                        ),
                        controller.dispElement(ElementsTypes.CrewCarrousel) ? DividerComponent(GlobalsColor.darkGreen, "Équipe") : Container(),
                        Container(
                          width: MediaQuery.of(context).size.width - 20,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 0),
                          transform: Matrix4.translationValues(0, -5, 0),
                          child: Theme(
                            data: Theme.of(context).copyWith(splashColor: GlobalsColor.darkGreen),
                            child: CrossFadeComponent(
                              child1: SkeletonCarrouselComponent(),
                              child2: controller.objectsStates[ElementsTypes.CrewCarrousel] == States.Added ? CarrouselView(QueryTypes.person, controller.carrouselData[ElementsTypes.CrewCarrousel]) : Padding(padding: EdgeInsets.all(0)),
                              dispFirst: controller.objectsStates[ElementsTypes.CrewCarrousel] == States.Loading,
                            ),
                          ),
                        ),
                        controller.dispElement(ElementsTypes.SimilarCarrousel) ? DividerComponent(GlobalsColor.darkGreen, "Films similaires") : Container(),
                        Container(
                          width: MediaQuery.of(context).size.width - 20,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 0),
                          transform: Matrix4.translationValues(0, -5, 0),
                          child: Theme(
                            data: Theme.of(context).copyWith(splashColor: GlobalsColor.darkGreen),
                            child: CrossFadeComponent(
                              child1: SkeletonCarrouselComponent(),
                              child2: controller.objectsStates[ElementsTypes.SimilarCarrousel] == States.Added ? CarrouselView(QueryTypes.movie, controller.carrouselData[ElementsTypes.SimilarCarrousel]) : Padding(padding: EdgeInsets.all(0)),
                              dispFirst: controller.objectsStates[ElementsTypes.SimilarCarrousel] == States.Loading,
                            ),
                          ),
                        ),
                        controller.dispElement(ElementsTypes.YoutubeTrailer) ? DividerComponent(GlobalsColor.darkGreen) : Container(),
                        controller.dispElement(ElementsTypes.YoutubeTrailer) ? Center(
                          child: Theme(
                            data: Theme.of(context).copyWith(splashColor: GlobalsColor.darkGreen),
                            child: TrailerComponent(controller.trailerKey, "Trailer du film", GlobalsColor.darkGreen),
                          ),
                        ) : Container(),  
                      ]),
                    ),
                  ],
                );
              }
            )
          );
        }
      )
    );
  }
}