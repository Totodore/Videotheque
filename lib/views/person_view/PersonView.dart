import 'package:Videotheque/components/CrossFadeComponent.dart';
import 'package:Videotheque/components/FABComponent.dart';
import 'package:Videotheque/components/HeaderComponent.dart';
import 'package:Videotheque/components/SliverAppBarComponent.dart';
import 'package:Videotheque/components/DividerComponent.dart';
import 'package:Videotheque/components/SkeletonCarrouselComponent.dart';
import 'package:Videotheque/components/SkeletonTagComponent.dart';

import 'package:Videotheque/Globals.dart';

import 'package:Videotheque/controllers/person_controller/PersonController.dart';

import 'package:Videotheque/views/components/CarrouselView.dart';
import 'package:Videotheque/views/person_view/TagView.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonView extends StatelessWidget {
  static final Color baseColor = GlobalsMessage.chipData[QueryTypes.values.indexOf(QueryTypes.person)]["color"];
  static final Color splashColor = GlobalsMessage.chipData[QueryTypes.values.indexOf(QueryTypes.person)]["splash_color"];
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => PersonController(context),
      child: Consumer<PersonController>( 
        builder: (BuildContext context, PersonController controller, Widget child) {
          return Scaffold(
            floatingActionButton: FABComponent(controller.isAdded, PersonView.baseColor, controller.isAdded ? controller.removePerson : controller.addPerson),
            body: Builder(
              builder: (context) {
                return CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverAppBarComponent(PersonView.baseColor, null, controller.preloadData["name"] ?? controller.preloadData["original_name"], controller.isAdded, controller.isFav, controller.onFavTapped),
                    SliverList(
                      delegate: SliverChildListDelegate([
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10, bottom: 0),
                            child: HeaderComponent(controller.preloadData["biography"], controller.heroTag, controller.preloadData["profile_path"], true),
                          ),
                          controller.isAdded && controller.preloadData["poster_path"] != null ? DividerComponent(PersonView.baseColor) : Container(),
                          controller.isAdded ? Container(
                            width: MediaQuery.of(context).size.width - 20,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(top: 0),
                            transform: Matrix4.translationValues(0, -5, 0),
                            child: Theme(
                              data: Theme.of(context).copyWith(splashColor: PersonView.splashColor),
                              child: CrossFadeComponent(
                                child1: SkeletonTagComponent(3),
                                child2: TagView(ElementsTypes.GenreTags, controller.addedGenreTags, controller.onAddTagTapped),
                                dispFirst: controller.objectsStates[ElementsTypes.GenreTags] == States.Loading,
                              ),
                            ),
                          ) : Container(),
                          controller.preloadData["poster_path"] != null ? DividerComponent(PersonView.baseColor) : Container(),
                          Container(
                            width: MediaQuery.of(context).size.width - 20,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(top: 0),
                            transform: Matrix4.translationValues(0, -5, 0),
                            child: Theme(
                              data: Theme.of(context).copyWith(splashColor: PersonView.splashColor),
                              child: CrossFadeComponent(
                                child1: SkeletonTagComponent(3),
                                child2: controller.objectsStates[ElementsTypes.InfoTags] == States.Added ? TagView(ElementsTypes.InfoTags, controller.loadedInfoTags, controller.onAddTagTapped) : Padding(padding: EdgeInsets.all(0)),
                                dispFirst: controller.objectsStates[ElementsTypes.InfoTags] == States.Loading,
                              ),
                            ),
                          ),
                          controller.dispElement(ElementsTypes.KnownForMovieCarrousel) ? DividerComponent(PersonView.baseColor, "Films") : Container(),
                          Container(
                            width: MediaQuery.of(context).size.width - 20,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(top: 0),
                            transform: Matrix4.translationValues(0, -5, 0),
                            child: Theme(
                              data: Theme.of(context).copyWith(splashColor: PersonView.splashColor),
                              child: CrossFadeComponent(
                                child1: SkeletonCarrouselComponent(),
                                child2: controller.objectsStates[ElementsTypes.KnownForMovieCarrousel] == States.Added ? CarrouselView(QueryTypes.movie, controller.carrouselData[ElementsTypes.KnownForMovieCarrousel]) : Padding(padding: EdgeInsets.all(0)),
                                dispFirst: controller.objectsStates[ElementsTypes.KnownForMovieCarrousel] == States.Loading,
                              ),
                            ),
                          ),
                          controller.dispElement(ElementsTypes.KnownForTvCarrousel) ? DividerComponent(PersonView.baseColor, "Séries") : Container(),
                          Container(
                            width: MediaQuery.of(context).size.width - 20,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(top: 0),
                            transform: Matrix4.translationValues(0, -5, 0),
                            child: Theme(
                              data: Theme.of(context).copyWith(splashColor: PersonView.splashColor),
                              child: CrossFadeComponent(
                                child1: SkeletonCarrouselComponent(),
                                child2: controller.objectsStates[ElementsTypes.KnownForTvCarrousel] == States.Added ? CarrouselView(QueryTypes.tv, controller.carrouselData[ElementsTypes.KnownForTvCarrousel]) : Padding(padding: EdgeInsets.all(0)),
                                dispFirst: controller.objectsStates[ElementsTypes.KnownForTvCarrousel] == States.Loading,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            ),
          );
        }
      ),
    );
  }
}