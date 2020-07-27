import 'package:Videotheque/components/divider_component.dart';
import 'package:Videotheque/controllers/library_controller/library_body_controller.dart';
import 'package:Videotheque/controllers/library_controller/library_body_header_controller.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/views/library_view/card_view.dart';
import 'package:Videotheque/views/library_view/carrousel_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibraryBodyHeaderView extends StatelessWidget {
  final Color mainColor;
  final Color splashColor;
  final QueryTypes type;
  final LibraryBodyController parentController;
  final List<ElementsTypes> optionsElems;
  final Map dataHeader;

  LibraryBodyHeaderView(this.mainColor, this.splashColor, this.type, this.parentController, this.optionsElems, this.dataHeader);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => LibraryBodyHeaderController(optionsElems, dataHeader),
      child: Consumer<LibraryBodyHeaderController>(
        builder: (context, controller, child) {
          return SliverToBoxAdapter(
            child: Column(
              children: optionsElems.map<Widget>((ElementsTypes elem) => Column(
                children: [
                  DividerComponent(
                    mainColor,
                    GlobalsMessage.chipData[QueryTypes.values.indexOf(type)][GlobalsMessage.libraryHeaderBodyViewType][elem]
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 20,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.topLeft,
                    child: Theme(
                      data: Theme.of(context).copyWith(splashColor: splashColor),
                      child: Builder(builder: (BuildContext context) {
                          if (controller.isSingleElement(elem))
                            return CardView(
                                controller.getFirstElementType(elem),
                                controller.getFirstElement(elem)
                              );
                          else
                            return CarrouselView(
                              elem,
                              controller.carrouselData[elem],
                              mainColor,
                              splashColor
                            );
                      }),
                    ),
                  ),
                ],
              )),
          ));
        }
      ),
    );
  }
}
