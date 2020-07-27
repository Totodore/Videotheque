import 'dart:ui';

import 'package:Videotheque/components/divider_component.dart';
import 'package:Videotheque/components/skeleton_carrousel_component.dart';
import 'package:Videotheque/components/skeleton_tag_component.dart';

import 'package:Videotheque/controllers/collection_controller/collection_controller.dart';

import 'package:Videotheque/views/collection_view/tag_view.dart';
import 'package:Videotheque/views/components/carrousel_view.dart';

import 'package:Videotheque/globals.dart';
import 'package:Videotheque/utils/utils.dart';

import 'package:background_app_bar/background_app_bar.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';
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
            floatingActionButton: FloatingActionButton(
              onPressed: controller.isAdded ? controller.removeCollection : controller.addCollection,
              backgroundColor: CollectionView.baseColor,
              elevation: 3,
              child: AnimatedCrossFade(
                firstChild: Icon(Icons.add,
                  color: Colors.white,
                  size: 25,
                ),
                secondChild: Icon(Icons.done,
                  color: Colors.white,
                  size: 25,
                ),
                crossFadeState: controller.isAdded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: Duration(milliseconds: 300),
              ),
            ),
            body: Builder(
              builder: (context) {
                BuildContext scaffoldContext = context;
                controller.scaffoldContext = context;
                return CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverAppBar(
                      forceElevated: true,
                      backgroundColor: CollectionView.baseColor,
                      pinned: true,
                      snap: false,
                      floating: false,
                      stretchTriggerOffset: 80,
                      onStretchTrigger: () async => Navigator.popUntil(context, ModalRoute.withName("/")),
                      stretch: false,
                      expandedHeight: controller.data["backdrop_path"] != null ? 175 + GlobalsData.endSortBarPos : kToolbarHeight,
                      elevation: 3,
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back,
                          color: controller.data["backdrop_path"] != null ? CollectionView.baseColor : Colors.white,
                          size: 38,
                        ),
                        onPressed: () => Navigator.popUntil(context, ModalRoute.withName("/")),
                      ),
                      title: controller.data["backdrop_path"] != null ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: SizedBox(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.black.withOpacity(0.4),
                            ),
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                              child: Text(controller.data["name"] != null ? controller.data["name"] : controller.data["name_title"],    
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ) : Text(controller.data["name"] != null ? controller.data["name"] : controller.data["name_title"],    
                        style: TextStyle(color: Colors.white),
                      ),           
                      actions: <Widget>[
                        controller.isAdded ? IconButton(icon: Icon(controller.isFav ? Icons.favorite : Icons.favorite_border, color: Colors.white), 
                          onPressed: () => controller.onFavTapped(scaffoldContext)
                        ) : Padding(padding: EdgeInsets.zero)
                      ],     
                      flexibleSpace: controller.data["backdrop_path"] != null ? BackgroundFlexibleSpaceBar(
                        title: Text(""),
                        collapseMode: CollapseMode.parallax,
                        background: ProgressiveImage(
                          placeholder: AssetImage("assets/loading.png"),
                          thumbnail: Utils.fetchImage(controller.data["backdrop_path"], ImageTypes.Backdrop, true),
                          image: Utils.fetchImage(controller.data["backdrop_path"], ImageTypes.Backdrop),
                          width: MediaQuery.of(context).size.width,
                          height: 175 + GlobalsData.endSortBarPos + kToolbarHeight,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          fadeDuration: Duration(milliseconds: 150),
                          blur: 4,
                          repeat: ImageRepeat.noRepeat,
                          matchTextDirection: true,
                        ),
                      ) : null,
                    ),
                    SliverList( 
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10, bottom: 0),
                          child: controller.dispElement(ElementsTypes.MainData) ? DropCapText(
                          controller.objectsStates[ElementsTypes.MainData] == States.Added ? controller.data["overview"] : "Chargement...",
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
                                    placeholder: AssetImage("assets/loading.png"),
                                    thumbnail: Utils.fetchImage(controller.data["poster_path"], ImageTypes.Poster, true),
                                    image: Utils.fetchImage(controller.data["poster_path"], ImageTypes.Poster),
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
                                    placeholder: AssetImage("assets/loading.png"),
                                    thumbnail: Utils.fetchImage(controller.data["poster_path"], ImageTypes.Poster, true),
                                    image: Utils.fetchImage(controller.data["poster_path"], ImageTypes.Poster),
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
                          child: controller.isAdded ? Builder(
                            builder: (BuildContext context) {
                              return ButtonBar(
                                buttonAlignedDropdown: true,
                                alignment: MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                layoutBehavior: ButtonBarLayoutBehavior.padded,
                                children: <Widget>[
                                  OutlineButton.icon(
                                    label: Text("Collection à voir", style: TextStyle(color: Colors.black)),
                                    icon: Icon(controller.isToSee ? CommunityMaterialIcons.eye_check_outline : CommunityMaterialIcons.eye_plus_outline, color: CollectionView.baseColor),
                                    color: CollectionView.baseColor,
                                    onPressed: () => controller.onCollectionToSeeTapped(scaffoldContext),
                                    borderSide: BorderSide(color: CollectionView.baseColor, width: 1.2),
                                    splashColor: CollectionView.splashColor,
                                    highlightedBorderColor: CollectionView.baseColor,
                                  ),
                                  OutlineButton.icon(
                                    label: Text("Collection vue", style: TextStyle(color: Colors.black)),
                                    icon: Icon(controller.isSeen ? CommunityMaterialIcons.eye_check : CommunityMaterialIcons.eye_plus, color: CollectionView.baseColor),
                                    onPressed: () => controller.onCollectionSeenTapped(scaffoldContext),
                                    borderSide: BorderSide(color: CollectionView.baseColor, width: 1.2),
                                    splashColor: CollectionView.splashColor,
                                    highlightedBorderColor: CollectionView.baseColor,
                                  ),
                                ],
                              );
                            }
                          ) : Padding(padding: EdgeInsets.zero),
                        ),
                        controller.isAdded ? DividerComponent(CollectionView.baseColor) : Padding(padding: EdgeInsets.zero),
                        controller.isAdded ? Container(
                          width: MediaQuery.of(context).size.width - 20,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 0),
                          transform: Matrix4.translationValues(0, -5, 0),
                          child: Theme(
                            data: Theme.of(context).copyWith(splashColor: CollectionView.splashColor),
                            child: AnimatedCrossFade(
                              firstChild: SkeletonTagComponent(3),
                              secondChild: TagView(ElementsTypes.GenreTags, controller.addedGenreTags, controller.onAddTagTapped),
                              crossFadeState: controller.objectsStates[ElementsTypes.GenreTags] != States.Loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                              duration: Duration(milliseconds: 200),
                            ),
                          ),
                        ) : Padding(padding: EdgeInsets.zero),
                        controller.dispElement(ElementsTypes.MoviesCarrousel) ? DividerComponent(CollectionView.baseColor, "Films") : Padding(padding: EdgeInsets.zero),
                        Container(
                          width: MediaQuery.of(context).size.width - 20,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(top: 0),
                          transform: Matrix4.translationValues(0, -5, 0),
                          child: Theme(
                            data: Theme.of(context).copyWith(splashColor: CollectionView.splashColor),
                            child: AnimatedCrossFade(
                              firstChild: SkeletonCarrouselComponent(),
                              secondChild: controller.objectsStates[ElementsTypes.MoviesCarrousel] == States.Added ? CarrouselView(QueryTypes.movie, controller.carrouselData[ElementsTypes.MoviesCarrousel]) : Padding(padding: EdgeInsets.all(0)),
                              crossFadeState: controller.objectsStates[ElementsTypes.MoviesCarrousel] != States.Loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                              duration: Duration(milliseconds: 200),
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