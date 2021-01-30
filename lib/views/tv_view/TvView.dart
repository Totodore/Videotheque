import 'dart:ui';

import 'package:Videotheque/components/FABComponent.dart';
import 'package:Videotheque/components/SliverAppBarComponent.dart';
import 'package:Videotheque/components/ToSeeSeenComponent.dart';
import 'package:Videotheque/controllers/tv_controller/tv_controller.dart';

import 'package:Videotheque/components/divider_component.dart';
import 'package:Videotheque/components/skeleton_carrousel_component.dart';
import 'package:Videotheque/components/skeleton_tag_component.dart';

import 'package:Videotheque/Globals.dart';
import 'package:Videotheque/utils/Utils.dart';

import 'package:Videotheque/views/tv_view/tag_view.dart';
import 'package:Videotheque/views/movie_view/trailer_view.dart';
import 'package:Videotheque/views/components/carrousel_view.dart';

import 'package:background_app_bar/background_app_bar.dart';
import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:provider/provider.dart';


class TvView extends StatelessWidget {
  static final Color baseColor = GlobalsMessage.chipData[QueryTypes.values.indexOf(QueryTypes.tv)]["color"];
  static final Color splashColor = GlobalsMessage.chipData[QueryTypes.values.indexOf(QueryTypes.tv)]["splash_color"];
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TvController>(
      create: (context) => TvController(context),
      child: Consumer<TvController>(
        builder: (context, controller, child) {
          return Scaffold(
            floatingActionButton: FABComponent(controller.isAdded, TvView.baseColor, controller.isAdded ? controller.removeTv : controller.addTv),
            body: Builder(
              builder: (context) {
                BuildContext scaffoldContext = context;
                controller.scaffoldContext = context;
                return CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverAppBarComponent(TvView.baseColor, controller.preloadData["backdrop_path"], controller.preloadData["name"] ?? controller.preloadData["original_name"], controller.isAdded, controller.isFav, controller.onFavTapped),
                    SliverList(
                      delegate: SliverChildListDelegate([
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10, bottom: 0),
                            child: controller.preloadData["overview"] != null && controller.preloadData["overview"].length > 2 ? DropCapText(
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
                          ),
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 150),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              final Animation<Offset> animationOffset = Tween<Offset>(begin: Offset(0.0, 0.3), end: Offset(0.0, 0.0)).animate(animation);
                              return FadeTransition(child: SlideTransition(child: child, position: animationOffset), opacity: animation);
                            },
                            child: controller.isAdded ? ToSeeSeenComponent(
                              () => controller.onTvToSeeTapped(scaffoldContext), 
                              () => controller.onTvSeenTapped(scaffoldContext), 
                              controller.isToSee, 
                              controller.isSeen, 
                              TvView.baseColor,
                              "Série à voir",
                              "Série vue") : Padding(padding: EdgeInsets.zero),
                          ),
                          controller.isAdded ? DividerComponent(TvView.baseColor) : Padding(padding: EdgeInsets.zero),
                          Container(
                            width: MediaQuery.of(context).size.width - 20,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.topLeft,
                            child: Theme(
                              data: Theme.of(context).copyWith(splashColor: TvView.splashColor),
                              child: AnimatedCrossFade(
                                firstChild: SkeletonTagComponent(controller.preloadData["genre_ids"].length + 1),
                                secondChild: controller.objectsStates[ElementsTypes.GenreTags] == States.Added ? TagView(ElementsTypes.GenreTags, controller.loadedGenreTags, controller.addedGenreTags, controller.isAdded, controller.onAddTagTapped): Padding(padding: EdgeInsets.all(0)),
                                crossFadeState: controller.objectsStates[ElementsTypes.GenreTags] != States.Loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                duration: Duration(milliseconds: 200),
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
                                secondChild: controller.objectsStates[ElementsTypes.InfoTags] == States.Added ? TagView(ElementsTypes.InfoTags, controller.loadedInfosTags, [], controller.isAdded, controller.onAddTagTapped) : Padding(padding: EdgeInsets.all(0)),
                                crossFadeState: controller.objectsStates[ElementsTypes.InfoTags] != States.Loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                duration: Duration(milliseconds: 200),
                              ),
                            ),
                          ),
                          controller.dispElement(ElementsTypes.MadeByCarrousel) ? DividerComponent(TvView.baseColor, "Créée par") : Padding(padding: EdgeInsets.zero),
                          Container(
                            width: MediaQuery.of(context).size.width - 20,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.topLeft,
                            child: Theme(
                              data: Theme.of(context).copyWith(splashColor: TvView.splashColor),
                              child: AnimatedCrossFade(
                                firstChild: SkeletonCarrouselComponent(),
                                secondChild: controller.objectsStates[ElementsTypes.MadeByCarrousel] == States.Added ? CarrouselView(QueryTypes.person, controller.carrouselData[ElementsTypes.MadeByCarrousel]) : Padding(padding: EdgeInsets.all(0)),
                                crossFadeState: controller.objectsStates[ElementsTypes.MadeByCarrousel] != States.Loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                duration: Duration(milliseconds: 200),
                              ),
                            ),
                          ),
                          controller.dispElement(ElementsTypes.SeasonsCarrousel) ? DividerComponent(TvView.baseColor, "Saisons") : Padding(padding: EdgeInsets.zero),
                          Container(
                            width: MediaQuery.of(context).size.width - 20,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.topLeft,
                            child: Theme(
                              data: Theme.of(context).copyWith(splashColor: TvView.splashColor),
                              child: AnimatedCrossFade(
                                firstChild: SkeletonCarrouselComponent(),
                                secondChild: controller.objectsStates[ElementsTypes.SeasonsCarrousel] == States.Added ? CarrouselView(QueryTypes.tv, controller.carrouselData[ElementsTypes.SeasonsCarrousel], controller.showSeasonEl) : Padding(padding: EdgeInsets.all(0)),
                                crossFadeState: controller.objectsStates[ElementsTypes.SeasonsCarrousel] != States.Loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                duration: Duration(milliseconds: 200),
                              ),
                            ),
                          ),
                          controller.objectsStates[ElementsTypes.CastingCarrousel] != States.Empty ? DividerComponent(TvView.baseColor, "Casting") : Padding(padding: EdgeInsets.zero),
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
                          controller.dispElement(ElementsTypes.SimilarCarrousel) ? DividerComponent(TvView.baseColor, "Séries similaires") : Padding(padding: EdgeInsets.zero),
                          Container(
                            width: MediaQuery.of(context).size.width - 20,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.topLeft,
                            child: Theme(
                              data: Theme.of(context).copyWith(splashColor: TvView.splashColor),
                              child: AnimatedCrossFade(
                                firstChild: SkeletonCarrouselComponent(),
                                secondChild: controller.objectsStates[ElementsTypes.SimilarCarrousel] == States.Added ? CarrouselView(QueryTypes.tv, controller.carrouselData[ElementsTypes.SimilarCarrousel]) : Padding(padding: EdgeInsets.all(0)),
                                crossFadeState: controller.objectsStates[ElementsTypes.SimilarCarrousel] != States.Loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
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
                        ]
                      ),
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