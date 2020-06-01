import 'dart:ui';

import 'package:Videotheque/components/divider_component.dart';
import 'package:Videotheque/components/skeleton_carrousel_component.dart';
import 'package:Videotheque/controllers/library_controller/library_body_controller.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/utils.dart';
import 'package:Videotheque/views/library_view/card_view.dart';
import 'package:Videotheque/views/library_view/carrousel_view.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class LibraryBodyView extends StatelessWidget {
  QueryTypes type;
  Color mainColor;
  Color splashColor;

  LibraryBodyView(this.type) {
    mainColor = Colors.grey[800];
    splashColor = GlobalsMessage.chipData[QueryTypes.values.indexOf(type)]["splash_color"];
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LibraryBodyController(context, type),
      child: Consumer<LibraryBodyController>(builder: (BuildContext context, controller, child) => 
      CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          controller.dispElement(ElementsTypes.ToSeeCarrousel) ? 
            SliverToBoxAdapter(child: DividerComponent(mainColor, GlobalsMessage.chipData[QueryTypes.values.indexOf(type)]["library_to_see"]))
            : SliverPadding(padding: EdgeInsets.zero),
          SliverToBoxAdapter(
            child: Container(
              width: MediaQuery.of(context).size.width - 20,
              margin: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.topLeft,
              child: Theme(
                data: Theme.of(context).copyWith(splashColor: splashColor),
                child: AnimatedCrossFade(
                  firstChild: SkeletonCarrouselComponent(),
                  secondChild: Builder(builder: (BuildContext context) {
                    if (controller.objectsStates[ElementsTypes.ToSeeCarrousel] == States.Added) {
                      if (controller.isSingleElement(ElementsTypes.ToSeeCarrousel))
                        return CardView(controller.getFirstElementType(ElementsTypes.ToSeeCarrousel), controller.getFirstElement(ElementsTypes.ToSeeCarrousel));
                      else 
                        return CarrouselView(ElementsTypes.ToSeeCarrousel, controller.carrouselData[ElementsTypes.ToSeeCarrousel], mainColor, splashColor);
                    } else {
                      return Padding(padding: EdgeInsets.all(0));
                    }
                  }),
                  crossFadeState: controller.objectsStates[ElementsTypes.ToSeeCarrousel] != States.Loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: Duration(milliseconds: 200),
                ),
              ),
            ),
          ),
          controller.dispElement(ElementsTypes.FavCarrousel) ?
            SliverToBoxAdapter(child: DividerComponent(mainColor, GlobalsMessage.chipData[QueryTypes.values.indexOf(type)]["library_fav"])) 
            : SliverPadding(padding: EdgeInsets.zero),
          SliverToBoxAdapter(
            child: Container(
              width: MediaQuery.of(context).size.width - 20,
              margin: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.topLeft,
              child: Theme(
                data: Theme.of(context).copyWith(splashColor: splashColor),
                child: AnimatedCrossFade(
                  firstChild: SkeletonCarrouselComponent(),
                  secondChild: Builder(builder: (BuildContext context) {
                    if (controller.objectsStates[ElementsTypes.FavCarrousel] == States.Added) {
                      if (controller.isSingleElement(ElementsTypes.FavCarrousel))
                        return CardView(controller.getFirstElementType(ElementsTypes.FavCarrousel), controller.getFirstElement(ElementsTypes.FavCarrousel));
                      else 
                        return CarrouselView(ElementsTypes.FavCarrousel, controller.carrouselData[ElementsTypes.FavCarrousel], mainColor, splashColor);
                    } else {
                      return Padding(padding: EdgeInsets.all(0));
                    }
                  }),
                  crossFadeState: controller.objectsStates[ElementsTypes.FavCarrousel] != States.Loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: Duration(milliseconds: 200),
                ),
              ),
            ),
          ),
          controller.dispElement(ElementsTypes.SeenCarrousel) ?
            SliverToBoxAdapter(child: DividerComponent(mainColor, GlobalsMessage.chipData[QueryTypes.values.indexOf(type)]["library_seen"])) 
            : SliverPadding(padding: EdgeInsets.zero),
          SliverToBoxAdapter(
            child: Container(
              width: MediaQuery.of(context).size.width - 20,
              margin: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.topLeft,
              child: Theme(
                data: Theme.of(context).copyWith(splashColor: splashColor),
                child: AnimatedCrossFade(
                  firstChild: SkeletonCarrouselComponent(),
                  secondChild: Builder(builder: (BuildContext context) {
                    if (controller.objectsStates[ElementsTypes.SeenCarrousel] == States.Added) {
                      if (controller.isSingleElement(ElementsTypes.SeenCarrousel))
                        return CardView(controller.getFirstElementType(ElementsTypes.SeenCarrousel), controller.getFirstElement(ElementsTypes.SeenCarrousel));
                      else 
                        return CarrouselView(ElementsTypes.SeenCarrousel, controller.carrouselData[ElementsTypes.SeenCarrousel], mainColor, splashColor);
                    } else {
                      return Padding(padding: EdgeInsets.all(0));
                    }
                  }),
                  crossFadeState: controller.objectsStates[ElementsTypes.SeenCarrousel] != States.Loading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: Duration(milliseconds: 200),
                ),
              ),
            ),
          ),
          controller.dispElement(ElementsTypes.MainData) ? SliverStickyHeaderBuilder(
            builder: (BuildContext context, SliverStickyHeaderState state) => AppBar(
              backgroundColor: state.isPinned ? Colors.white.withOpacity(0.4) : Colors.transparent,
              // leading: Padding(padding: EdgeInsets.zero),
              automaticallyImplyLeading: false,
              elevation: state.isPinned ? 4 : 0,
              titleSpacing: 0,
              title: ClipRect(
                child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), child: AppBar(
                  backgroundColor: Colors.white.withOpacity(0.4),
                  // leading: Padding(padding: EdgeInsets.zero),
                  elevation: 0,
                  automaticallyImplyLeading: false,

                  title: Text(GlobalsMessage.chipData[QueryTypes.values.indexOf(type)]["library_appBar"], style: TextStyle(color: Colors.grey[800])),
                  actions: <Widget>[
                    IconButton(icon: Icon(Icons.search, color: Colors.grey[800], size: 30)),
                    Padding(padding: EdgeInsets.only(right: 5)),
                    IconButton(icon: Icon(Icons.filter_list, color: Colors.grey[800], size: 30)),
                    Padding(padding: EdgeInsets.only(right: 16))
                  ],
                )),
              ),
            ),
            sliver: SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                // maxCrossAxisExtent: MediaQuery.of(context).size.width/2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.67,
                children: List.generate(controller.libraryLength, (index) {
                  String heroTag = controller.heroTag;
                  return RaisedButton(
                    elevation: 2,
                    clipBehavior: Clip.hardEdge,
                    onPressed: () => controller.onElementTapped(index, heroTag),
                    highlightElevation: 4,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    child: Stack(
                      children: <Widget>[
                        Hero(
                          tag: heroTag,
                          child: ProgressiveImage(
                            placeholder: AssetImage("assets/loading.png"),
                            thumbnail: Utils.fetchImage(controller.getImageElement(index), controller.getImageType(index), true),
                            image: Utils.fetchImage(controller.getImageElement(index), controller.getImageType(index)),
                            width: 400,
                            height: 600,
                            fit: BoxFit.fitHeight,
                            fadeDuration: Duration(milliseconds: 150),
                            blur: 2,                      
                          ),
                        ),
                        controller.getElementType(index) == QueryTypes.person ? Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          height: 40,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(controller.getNameElement(index) ?? "", style: TextStyle(
                              color: Colors.white,
                              fontSize: 17
                            ), maxLines: 1),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: FractionalOffset.bottomCenter,
                                end: FractionalOffset.topCenter,
                                colors: [
                                  Colors.black.withAlpha(160),
                                  Colors.black.withAlpha(0)
                                ]
                              )
                            ),
                          ),
                        ) : Padding(padding: EdgeInsets.zero)
                      ],
                    ),
                  );
                })
              ),
            )
          ) : SliverToBoxAdapter(child: Container())
        ]
      )),
    );
  }
}