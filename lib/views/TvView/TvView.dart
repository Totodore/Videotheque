import 'dart:ui';

import 'package:Videotheque/components/CrossFadeComponent.dart';
import 'package:Videotheque/components/FABComponent.dart';
import 'package:Videotheque/components/HeaderComponent.dart';
import 'package:Videotheque/components/SliverAppBarComponent.dart';
import 'package:Videotheque/components/ToSeeSeenComponent.dart';
import 'package:Videotheque/components/TrailerComponent.dart';
import 'package:Videotheque/controllers/TvController/TvController.dart';

import 'package:Videotheque/components/DividerComponent.dart';
import 'package:Videotheque/components/SkeletonCarrouselComponent.dart';
import 'package:Videotheque/components/SkeletonTagComponent.dart';

import 'package:Videotheque/Globals.dart';

import 'package:Videotheque/views/TvView/TagView.dart';
import 'package:Videotheque/views/components/CarrouselView.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';


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
            body: Builder(builder: (context) {
                BuildContext scaffoldContext = context;
                controller.scaffoldContext = context;
                return SnappingSheet(
                  snappingSheetController: controller.sheetController,
                  lockOverflowDrag: true,
                  initSnapPosition: SnapPosition(positionFactor: 0, snappingDuration: const Duration(milliseconds: 200), snappingCurve: Curves.ease),
                  snapPositions: [
                    SnapPosition(positionFactor: 0, snappingDuration: const Duration(milliseconds: 200), snappingCurve: Curves.ease),
                    SnapPosition(positionFactor: 0.8, snappingDuration: const Duration(milliseconds: 200), snappingCurve: Curves.ease),
                    SnapPosition(positionPixel: MediaQuery.of(context).size.height - kToolbarHeight - 35*2, snappingDuration: const Duration(milliseconds: 200), snappingCurve: Curves.ease)
                  ],
                  child: getTvView(controller, scaffoldContext),
                  sheetBelow: SnappingSheetContent(
                    draggable: true,
                    heightBehavior: SnappingSheetHeight.fit(),
                    child: controller.getSeasonEl()
                  ),
                  grabbingHeight: controller.showModal ? 35 : 0,
                  grabbing: grabSection(context),
                );
              }
            )
          );
        }
      )
    );
  }

  Widget getTvView(controller, scaffoldContext) => CustomScrollView(
    physics: BouncingScrollPhysics(),
    slivers: <Widget>[
      SliverAppBarComponent(TvView.baseColor, controller.preloadData["backdrop_path"], controller.preloadData["name"] ?? controller.preloadData["original_name"], controller.isAdded, controller.isFav, controller.onFavTapped),
      SliverList(
        delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10, bottom: 0),
              child: HeaderComponent(controller.preloadData["overview"], controller.heroTag, controller.preloadData["poster_path"], false)
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
                "Série vue") : Container(),
            ),
            controller.isAdded ? DividerComponent(TvView.baseColor) : Container(),
            Container(
              width: MediaQuery.of(scaffoldContext).size.width - 20,
              margin: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.topLeft,
              child: Theme(
                data: Theme.of(scaffoldContext).copyWith(splashColor: TvView.splashColor),
                child: CrossFadeComponent(
                  child1: SkeletonTagComponent(controller.preloadData["genre_ids"].length + 1),
                  child2: controller.objectsStates[ElementsTypes.GenreTags] == States.Added ? TagView(ElementsTypes.GenreTags, controller.loadedGenreTags, controller.addedGenreTags, controller.isAdded, controller.onAddTagTapped): Padding(padding: EdgeInsets.all(0)),
                  dispFirst: controller.objectsStates[ElementsTypes.GenreTags] == States.Loading,
                ),
              ),
            ),
            controller.dispElement(ElementsTypes.InfoTags) ? DividerComponent(TvView.baseColor) : Container(),
            Container(
              width: MediaQuery.of(scaffoldContext).size.width - 20,
              margin: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.topLeft,
              child: Theme(
                data: Theme.of(scaffoldContext).copyWith(splashColor: TvView.splashColor),
                child: CrossFadeComponent(
                  child1: SkeletonTagComponent(3),
                  child2: controller.objectsStates[ElementsTypes.InfoTags] == States.Added ? TagView(ElementsTypes.InfoTags, controller.loadedInfosTags, [], controller.isAdded, controller.onAddTagTapped) : Padding(padding: EdgeInsets.all(0)),
                  dispFirst: controller.objectsStates[ElementsTypes.InfoTags] == States.Loading,
                ),
              ),
            ),
            controller.dispElement(ElementsTypes.MadeByCarrousel) ? DividerComponent(TvView.baseColor, "Créée par") : Container(),
            Container(
              width: MediaQuery.of(scaffoldContext).size.width - 20,
              margin: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.topLeft,
              child: Theme(
                data: Theme.of(scaffoldContext).copyWith(splashColor: TvView.splashColor),
                child: CrossFadeComponent(
                  child1: SkeletonCarrouselComponent(),
                  child2: controller.objectsStates[ElementsTypes.MadeByCarrousel] == States.Added ? CarrouselView(QueryTypes.person, controller.carrouselData[ElementsTypes.MadeByCarrousel]) : Padding(padding: EdgeInsets.all(0)),
                  dispFirst: controller.objectsStates[ElementsTypes.MadeByCarrousel] == States.Loading,
                ),
              ),
            ),
            controller.dispElement(ElementsTypes.SeasonsCarrousel) ? DividerComponent(TvView.baseColor, "Saisons") : Container(),
            Container(
              width: MediaQuery.of(scaffoldContext).size.width - 20,
              margin: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.topLeft,
              child: Theme(
                data: Theme.of(scaffoldContext).copyWith(splashColor: TvView.splashColor),
                child: CrossFadeComponent(
                  child1: SkeletonCarrouselComponent(),
                  child2: controller.objectsStates[ElementsTypes.SeasonsCarrousel] == States.Added ? CarrouselView(QueryTypes.tv, controller.carrouselData[ElementsTypes.SeasonsCarrousel], controller.showSeasonEl) : Padding(padding: EdgeInsets.all(0)),
                  dispFirst: controller.objectsStates[ElementsTypes.SeasonsCarrousel] == States.Loading,
                ),
              ),
            ),
            controller.objectsStates[ElementsTypes.CastingCarrousel] != States.Empty ? DividerComponent(TvView.baseColor, "Casting") : Container(),
            Container(
              width: MediaQuery.of(scaffoldContext).size.width - 20,
              margin: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.topLeft,
              child: Theme(
                data: Theme.of(scaffoldContext).copyWith(splashColor: TvView.splashColor),
                child: CrossFadeComponent(
                  child1: SkeletonCarrouselComponent(),
                  child2: controller.objectsStates[ElementsTypes.CastingCarrousel] == States.Added ? CarrouselView(QueryTypes.person, controller.carrouselData[ElementsTypes.CastingCarrousel]) : Padding(padding: EdgeInsets.all(0)),
                  dispFirst: controller.objectsStates[ElementsTypes.CastingCarrousel] == States.Loading,
                ),
              ),
            ),
            controller.dispElement(ElementsTypes.CrewCarrousel) ? DividerComponent(TvView.baseColor, "Équipe") : Container(),
            Container(
              width: MediaQuery.of(scaffoldContext).size.width - 20,
              margin: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.topLeft,
              child: Theme(
                data: Theme.of(scaffoldContext).copyWith(splashColor: TvView.splashColor),
                child: CrossFadeComponent(
                  child1: SkeletonCarrouselComponent(),
                  child2: controller.objectsStates[ElementsTypes.CrewCarrousel] == States.Added ? CarrouselView(QueryTypes.person, controller.carrouselData[ElementsTypes.CrewCarrousel]) : Padding(padding: EdgeInsets.all(0)),
                  dispFirst: controller.objectsStates[ElementsTypes.CrewCarrousel] == States.Loading,
                ),
              ),
            ),
            controller.dispElement(ElementsTypes.SimilarCarrousel) ? DividerComponent(TvView.baseColor, "Séries similaires") : Container(),
            Container(
              width: MediaQuery.of(scaffoldContext).size.width - 20,
              margin: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.topLeft,
              child: Theme(
                data: Theme.of(scaffoldContext).copyWith(splashColor: TvView.splashColor),
                child: CrossFadeComponent(
                  child1: SkeletonCarrouselComponent(),
                  child2: controller.objectsStates[ElementsTypes.SimilarCarrousel] == States.Added ? CarrouselView(QueryTypes.tv, controller.carrouselData[ElementsTypes.SimilarCarrousel]) : Padding(padding: EdgeInsets.all(0)),
                  dispFirst: controller.objectsStates[ElementsTypes.SimilarCarrousel] == States.Loading,
                ),
              ),
            ),
            controller.dispElement(ElementsTypes.YoutubeTrailer) ? DividerComponent(TvView.baseColor) : Container(),
            controller.objectsStates[ElementsTypes.YoutubeTrailer] == States.Added ? Center(
              child: Theme(
                data: Theme.of(scaffoldContext).copyWith(splashColor: TvView.splashColor),
                child: TrailerComponent(controller.trailerKey, "Trailer de la série", TvView.baseColor),
              ),
            ) : Container(),
          ]
        ),
      ),
      SliverToBoxAdapter(
        child: controller.getSeasonEl(),
      )
    ],
  );

  Widget grabSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(
          blurRadius: 20.0,
          color: Colors.black.withOpacity(0.2),
        )],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 200.0,
            height: 5.0,
            margin: EdgeInsets.only(top: 15.0),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(Radius.circular(5.0))
            ),
          ),
        ],
      ),
    );
  }
}