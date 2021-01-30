
import 'dart:ui';

import 'package:Videotheque/components/FABComponent.dart';
import 'package:Videotheque/components/SliverAppBarComponent.dart';
import 'package:Videotheque/components/ToSeeSeenComponent.dart';
import 'package:background_app_bar/background_app_bar.dart';
import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:provider/provider.dart';

import 'package:Videotheque/utils/Utils.dart';
import 'package:Videotheque/Globals.dart';

import 'package:Videotheque/views/movie_view/tag_view.dart';
import 'package:Videotheque/views/movie_view/trailer_view.dart';
import 'package:Videotheque/views/components/carrousel_view.dart';

import 'package:Videotheque/controllers/movie_controller/movie_controller.dart';

import 'package:Videotheque/components/skeleton_carrousel_component.dart';
import 'package:Videotheque/components/skeleton_tag_component.dart';
import 'package:Videotheque/components/divider_component.dart';

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
                          child: (controller.preloadData["overview"]?.toString()?.length ?? 0) > 0 ? DropCapText(
                            controller.preloadData["overview"],
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
                              child: Card(
                                elevation: 3,
                                margin: EdgeInsets.only(bottom: 0),
                                child: Hero(
                                  tag: controller.heroTag,
                                  child: ProgressiveImage(
                                    placeholder: AssetImage("assets/img/loading.png"),
                                    thumbnail: Utils.fetchImage(controller.preloadData["poster_path"], ImageTypes.Poster, true),
                                    image: Utils.fetchImage(controller.preloadData["poster_path"], ImageTypes.Poster),
                                    width: 160,
                                    height: 240,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ) : Container(
                            width: 160,
                            height: 240,
                            margin: const EdgeInsets.only(bottom: 10),
                            alignment: Alignment.centerLeft,
                            child: Card(
                              elevation: 3,
                              margin: EdgeInsets.only(bottom: 0),
                              child: Hero(
                                tag: controller.heroTag,
                                child: ProgressiveImage(
                                  placeholder: AssetImage("assets/img/loading.png"),
                                  thumbnail: Utils.fetchImage(controller.preloadData["poster_path"], ImageTypes.Poster, true),
                                  image: Utils.fetchImage(controller.preloadData["poster_path"], ImageTypes.Poster),
                                  width: 160,
                                  height: 240,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
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
                            "Film vu") : Padding(padding: EdgeInsets.zero),
                        ),
                        controller.isAdded ? DividerComponent(GlobalsColor.darkGreen) : Padding(padding: EdgeInsets.zero),
                        Container(
                          width: MediaQuery.of(context).size.width - 20,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 0),
                          transform: Matrix4.translationValues(0, -5, 0),
                          child: Theme(
                            data: Theme.of(context).copyWith(splashColor: GlobalsMessage.chipData[1]["splash_color"]),
                            child: AnimatedCrossFade(
                              firstChild: SkeletonTagComponent(controller.preloadData["genre_ids"].length + 1),
                              secondChild: controller.objectsStates[ElementsTypes.GenreTags] == States.Added ? TagView(ElementsTypes.GenreTags, controller.loadedGenreTags, controller.addedGenreTags, controller.isAdded, controller.onAddTagTapped): Padding(padding: EdgeInsets.all(0)),
                              crossFadeState: controller.objectsStates[ElementsTypes.GenreTags] != States.Loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                              duration: Duration(milliseconds: 200),
                            ),
                          ),
                        ),
                        controller.dispElement(ElementsTypes.InfoTags) ? DividerComponent(GlobalsColor.darkGreen) : Padding(padding: EdgeInsets.zero),
                        Container(
                          width: MediaQuery.of(context).size.width - 20,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 0),
                          transform: Matrix4.translationValues(0, -5, 0),
                          child: Theme(
                            data: Theme.of(context).copyWith(splashColor: GlobalsMessage.chipData[1]["splash_color"]),
                            child: AnimatedCrossFade(
                              firstChild: SkeletonTagComponent(3),
                              secondChild: controller.objectsStates[ElementsTypes.InfoTags] == States.Added ? TagView(ElementsTypes.InfoTags, controller.loadedInfosTags, [], controller.isAdded, controller.onAddTagTapped) : Padding(padding: EdgeInsets.all(0)),
                              crossFadeState: controller.objectsStates[ElementsTypes.InfoTags] != States.Loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                              duration: Duration(milliseconds: 200),
                            ),
                          ),
                        ),
                        controller.dispElement(ElementsTypes.CastingCarrousel) ? DividerComponent(GlobalsColor.darkGreen, "Casting") : Padding(padding: EdgeInsets.zero),
                        Container(
                          width: MediaQuery.of(context).size.width - 20,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 0),
                          transform: Matrix4.translationValues(0, -5, 0),
                          child: Theme(
                            data: Theme.of(context).copyWith(splashColor: GlobalsMessage.chipData[1]["splash_color"]),
                            child: AnimatedCrossFade(
                              firstChild: SkeletonCarrouselComponent(),
                              secondChild: controller.objectsStates[ElementsTypes.CastingCarrousel] == States.Added ? CarrouselView(QueryTypes.person, controller.carrouselData[ElementsTypes.CastingCarrousel]) : Padding(padding: EdgeInsets.all(0)),
                              crossFadeState: controller.objectsStates[ElementsTypes.CastingCarrousel] != States.Loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                              duration: Duration(milliseconds: 200),
                            ),
                          ),
                        ),
                        controller.dispElement(ElementsTypes.CrewCarrousel) ? DividerComponent(GlobalsColor.darkGreen, "Équipe") : Padding(padding: EdgeInsets.zero),
                        Container(
                          width: MediaQuery.of(context).size.width - 20,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 0),
                          transform: Matrix4.translationValues(0, -5, 0),
                          child: Theme(
                            data: Theme.of(context).copyWith(splashColor: GlobalsMessage.chipData[1]["splash_color"]),
                            child: AnimatedCrossFade(
                              firstChild: SkeletonCarrouselComponent(),
                              secondChild: controller.objectsStates[ElementsTypes.CrewCarrousel] == States.Added ? CarrouselView(QueryTypes.person, controller.carrouselData[ElementsTypes.CrewCarrousel]) : Padding(padding: EdgeInsets.all(0)),
                              crossFadeState: controller.objectsStates[ElementsTypes.CrewCarrousel] != States.Loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                              duration: Duration(milliseconds: 200),
                            ),
                          ),
                        ),
                        controller.dispElement(ElementsTypes.SimilarCarrousel) ? DividerComponent(GlobalsColor.darkGreen, "Films similaires") : Padding(padding: EdgeInsets.zero),
                        Container(
                          width: MediaQuery.of(context).size.width - 20,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 0),
                          transform: Matrix4.translationValues(0, -5, 0),
                          child: Theme(
                            data: Theme.of(context).copyWith(splashColor: GlobalsMessage.chipData[1]["splash_color"]),
                            child: AnimatedCrossFade(
                              firstChild: SkeletonCarrouselComponent(),
                              secondChild: controller.objectsStates[ElementsTypes.SimilarCarrousel] == States.Added ? CarrouselView(QueryTypes.movie, controller.carrouselData[ElementsTypes.SimilarCarrousel]) : Padding(padding: EdgeInsets.all(0)),
                              crossFadeState: controller.objectsStates[ElementsTypes.SimilarCarrousel] != States.Loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                              duration: Duration(milliseconds: 200),
                            ),
                          ),
                        ),
                        controller.dispElement(ElementsTypes.YoutubeTrailer) ? DividerComponent(GlobalsColor.darkGreen) : Padding(padding: EdgeInsets.zero),
                        controller.dispElement(ElementsTypes.YoutubeTrailer) ? Center(
                          child: Theme(
                            data: Theme.of(context).copyWith(splashColor: GlobalsMessage.chipData[1]["splash_color"]),
                            child: TrailerView(controller.trailerKey),
                          ),
                        ) : Padding(padding: EdgeInsets.zero),  
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