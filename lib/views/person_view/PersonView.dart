import 'package:Videotheque/components/FABComponent.dart';
import 'package:Videotheque/components/SliverAppBarComponent.dart';
import 'package:Videotheque/components/divider_component.dart';
import 'package:Videotheque/components/skeleton_carrousel_component.dart';
import 'package:Videotheque/components/skeleton_tag_component.dart';

import 'package:Videotheque/Globals.dart';
import 'package:Videotheque/utils/Utils.dart';

import 'package:Videotheque/controllers/person_controller/person_controller.dart';

import 'package:Videotheque/views/components/carrousel_view.dart';
import 'package:Videotheque/views/person_view/tag_view.dart';

import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';
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
                    SliverAppBarComponent(PersonView.baseColor, controller.preloadData["backdrop_path"], controller.preloadData["name"] ?? controller.preloadData["original_name"], controller.isAdded, controller.isFav, controller.onFavTapped),
                    SliverList(
                      delegate: SliverChildListDelegate([
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10, bottom: 0),
                            child: controller.objectsStates[ElementsTypes.MainData] != States.Empty ? DropCapText(
                              controller.objectsStates[ElementsTypes.MainData] == States.Added ? controller.mainData["biography"] : "Chargement...",
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
                                      thumbnail: Utils.fetchImage(controller.preloadData["profile_path"], ImageTypes.Profile, true),
                                      image: Utils.fetchImage(controller.preloadData["profile_path"], ImageTypes.Profile),
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
                                      thumbnail: Utils.fetchImage(controller.preloadData["profile_path"], ImageTypes.Profile, true),
                                      image: Utils.fetchImage(controller.preloadData["profile_path"], ImageTypes.Profile),
                                      width: 160,
                                      height: 240,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          controller.isAdded ? DividerComponent(PersonView.baseColor) : Container(),
                          controller.isAdded ? Container(
                            width: MediaQuery.of(context).size.width - 20,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(top: 0),
                            transform: Matrix4.translationValues(0, -5, 0),
                            child: Theme(
                              data: Theme.of(context).copyWith(splashColor: PersonView.splashColor),
                              child: AnimatedCrossFade(
                                firstChild: SkeletonTagComponent(3),
                                secondChild: TagView(ElementsTypes.GenreTags, controller.addedGenreTags, controller.onAddTagTapped),
                                crossFadeState: controller.objectsStates[ElementsTypes.GenreTags] != States.Loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                duration: Duration(milliseconds: 200),
                              ),
                            ),
                          ) : Container(),
                          DividerComponent(PersonView.baseColor),
                          Container(
                            width: MediaQuery.of(context).size.width - 20,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(top: 0),
                            transform: Matrix4.translationValues(0, -5, 0),
                            child: Theme(
                              data: Theme.of(context).copyWith(splashColor: PersonView.splashColor),
                              child: AnimatedCrossFade(
                                firstChild: SkeletonTagComponent(3),
                                secondChild: controller.objectsStates[ElementsTypes.InfoTags] == States.Added ? TagView(ElementsTypes.InfoTags, controller.loadedInfoTags, controller.onAddTagTapped) : Padding(padding: EdgeInsets.all(0)),
                                crossFadeState: controller.objectsStates[ElementsTypes.InfoTags] != States.Loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                duration: Duration(milliseconds: 200),
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
                              child: AnimatedCrossFade(
                                firstChild: SkeletonCarrouselComponent(),
                                secondChild: controller.objectsStates[ElementsTypes.KnownForMovieCarrousel] == States.Added ? CarrouselView(QueryTypes.movie, controller.carrouselData[ElementsTypes.KnownForMovieCarrousel]) : Padding(padding: EdgeInsets.all(0)),
                                crossFadeState: controller.objectsStates[ElementsTypes.KnownForMovieCarrousel] != States.Loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                duration: Duration(milliseconds: 200),
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
                              child: AnimatedCrossFade(
                                firstChild: SkeletonCarrouselComponent(),
                                secondChild: controller.objectsStates[ElementsTypes.KnownForTvCarrousel] == States.Added ? CarrouselView(QueryTypes.tv, controller.carrouselData[ElementsTypes.KnownForTvCarrousel]) : Padding(padding: EdgeInsets.all(0)),
                                crossFadeState: controller.objectsStates[ElementsTypes.KnownForTvCarrousel] != States.Loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                duration: Duration(milliseconds: 200),
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