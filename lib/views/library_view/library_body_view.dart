import 'package:Videotheque/components/divider_component.dart';
import 'package:Videotheque/components/skeleton_carrousel_component.dart';
import 'package:Videotheque/controllers/library_controller/library_body_controller.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/views/library_view/card_view.dart';
import 'package:Videotheque/views/library_view/carrousel_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibraryBodyView extends StatelessWidget {
  QueryTypes type;
  Color mainColor;
  Color splashColor;

  LibraryBodyView(this.type) {
    mainColor = GlobalsMessage.chipData[QueryTypes.values.indexOf(type)]["color"];
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
          SliverPadding(padding: EdgeInsets.only(top: 20)),
          controller.dispElement(ElementsTypes.ToSeeCarrousel) ? 
            SliverToBoxAdapter(child: DividerComponent(mainColor, type == QueryTypes.all ? "À voir" : "${GlobalsMessage.chipData[QueryTypes.values.indexOf(type)]["keyword"]} à voir")) 
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
            SliverToBoxAdapter(child: DividerComponent(mainColor, type == QueryTypes.all ? "Favoris" : "${GlobalsMessage.chipData[QueryTypes.values.indexOf(type)]["keyword"]} favoris")) 
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
            SliverToBoxAdapter(child: DividerComponent(mainColor, type == QueryTypes.all ? "À voir" : "${GlobalsMessage.chipData[QueryTypes.values.indexOf(type)]["keyword"]} vus")) 
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
        ]
      )),
    );
  }
}