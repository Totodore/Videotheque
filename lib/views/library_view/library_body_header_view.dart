import 'package:Videotheque/components/DividerComponent.dart';
import 'package:Videotheque/controllers/library_controller/library_body_controller.dart';
import 'package:Videotheque/controllers/library_controller/library_body_header_controller.dart';
import 'package:Videotheque/Globals.dart';
import 'package:Videotheque/views/library_view/carrousel_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibraryBodyHeaderView extends StatelessWidget {
  final Color mainColor;
  final Color splashColor;
  final QueryTypes type;
  final LibraryBodyController parentController;
  final List<ElementsTypes> optionsElems;

  LibraryBodyHeaderView(this.mainColor, this.splashColor, this.type, this.parentController, this.optionsElems);

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (BuildContext context) => LibraryBodyHeaderController(optionsElems, parentController),
      child: Consumer<LibraryBodyHeaderController>(
        builder: (context, controller, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20)
              ),
            ]..addAll(List.generate(optionsElems.length, (index) {
              ElementsTypes elem = optionsElems[index];
              if ((elem == ElementsTypes.SeenCarrousel || elem == ElementsTypes.ToSeeCarrousel) && type == QueryTypes.person) return Container(); 
              if (controller.isEmpty(elem)) return Container();
              return Column(
                children: [
                  DividerComponent(
                    mainColor,
                    GlobalsMessage.chipData[QueryTypes.values.indexOf(type)][GlobalsMessage.libraryHeaderBodyViewType[elem]]
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 20,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.topLeft,
                    child: Theme(
                      data: Theme.of(context).copyWith(splashColor: splashColor),
                      child: Builder(builder: (BuildContext context) => CarrouselView(
                        elem,
                        controller.carrouselData[elem],
                        mainColor,
                        splashColor
                      )),
                    ),
                  ),
                ],
              );
            })),
          );
        }
      ),
    );
  }
}
