import 'dart:ui';

import 'package:Videotheque/components/CrossFadeComponent.dart';
import 'package:Videotheque/components/FABComponent.dart';
import 'package:Videotheque/components/HeaderComponent.dart';
import 'package:Videotheque/components/SliverAppBarComponent.dart';
import 'package:Videotheque/components/ToSeeSeenComponent.dart';
import 'package:Videotheque/components/DividerComponent.dart';
import 'package:Videotheque/components/SkeletonCarrouselComponent.dart';
import 'package:Videotheque/components/SkeletonTagComponent.dart';

import 'package:Videotheque/controllers/collection_controller/collection_controller.dart';

import 'package:Videotheque/views/collection_view/tag_view.dart';
import 'package:Videotheque/views/components/carrousel_view.dart';

import 'package:Videotheque/Globals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CollectionView extends StatelessWidget {
  static final Color baseColor = GlobalsMessage.chipData[QueryTypes.values.indexOf(QueryTypes.collection)]["color"];
  static final Color splashColor = GlobalsMessage.chipData[QueryTypes.values.indexOf(QueryTypes.collection)]["splash_color"];
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CollectionController>(
      create: (context) => CollectionController(context),
      child: Consumer<CollectionController>(
        builder: (context, controller, child) {
          return Scaffold(
            floatingActionButton: FABComponent(controller.isAdded, CollectionView.baseColor, controller.isAdded ? controller.removeCollection : controller.addCollection),
            body: Builder(
              builder: (context) {
                BuildContext scaffoldContext = context;
                controller.scaffoldContext = context;
                return CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverAppBarComponent(CollectionView.baseColor, controller.data["backdrop_path"], controller.data["name"] ?? controller.data["original_name"], controller.isAdded, controller.isFav, controller.onFavTapped),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10, bottom: 0),
                          child: HeaderComponent(controller.data["overview"], controller.heroTag, controller.data["poster_path"], false)
                        ),
                        AnimatedSwitcher(
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            final Animation<Offset> animationOffset = Tween<Offset>(begin: Offset(0.0, 0.3), end: Offset(0.0, 0.0)).animate(animation);
                            return FadeTransition(child: SlideTransition(child: child, position: animationOffset), opacity: animation);
                          },
                          duration: const Duration(milliseconds: 250),
                          child: controller.isAdded ? ToSeeSeenComponent(
                            () => controller.onCollectionToSeeTapped(scaffoldContext), 
                            () => controller.onCollectionSeenTapped(scaffoldContext),
                            controller.isToSee, 
                            controller.isSeen, 
                            CollectionView.baseColor,
                            "Collection à voir",
                            "Collection vue") : Container(),
                        ),
                        controller.isAdded ? DividerComponent(CollectionView.baseColor) : Container(),
                        controller.isAdded ? Container(
                          width: MediaQuery.of(context).size.width - 20,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 0),
                          transform: Matrix4.translationValues(0, -5, 0),
                          child: Theme(
                            data: Theme.of(context).copyWith(splashColor: CollectionView.splashColor),
                            child: CrossFadeComponent(
                              child1: SkeletonTagComponent(3),
                              child2: TagView(ElementsTypes.GenreTags, controller.addedGenreTags, controller.onAddTagTapped),
                              dispFirst: controller.objectsStates[ElementsTypes.GenreTags] == States.Loading
                            ),
                          ),
                        ) : Container(),
                        controller.dispElement(ElementsTypes.MoviesCarrousel) ? DividerComponent(CollectionView.baseColor, "Films") : Container(),
                        Container(
                          width: MediaQuery.of(context).size.width - 20,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 0),
                          transform: Matrix4.translationValues(0, -5, 0),
                          child: Theme(
                            data: Theme.of(context).copyWith(splashColor: CollectionView.splashColor),
                            child: CrossFadeComponent(
                              child1: SkeletonCarrouselComponent(),
                              child2: controller.objectsStates[ElementsTypes.MoviesCarrousel] == States.Added ? CarrouselView(QueryTypes.movie, controller.carrouselData[ElementsTypes.MoviesCarrousel]) : Padding(padding: EdgeInsets.all(0)),
                              dispFirst: controller.objectsStates[ElementsTypes.MoviesCarrousel] == States.Loading,
                            ),
                          ),
                        ),
                      ])
                    ),
                  ]
                );
              }
            )
          );
        }
      )
    );
  }     
}