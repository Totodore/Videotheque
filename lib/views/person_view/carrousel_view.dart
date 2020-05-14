
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/views/person_view/person_view.dart';
import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:provider/provider.dart';
import 'package:Videotheque/utils.dart';

import 'package:Videotheque/controllers/person_controller/carrousel_controller.dart';

class CarrouselView extends StatelessWidget {
  ElementsTypes type;
  List dataCarrousel;

  CarrouselView(this.type, this.dataCarrousel);
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CarrouselController(context, type, dataCarrousel),
      child: Consumer<CarrouselController>(
        builder: (context, controller, child) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: List.generate(controller.carrouselData.length, (int index) {
                  String heroTag = controller.heroTag;
                  return Card(
                    elevation: 1,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () => controller.onElementTapped(index, heroTag),
                      splashColor: PersonView.splashColor,
                      child: Column(
                        children: <Widget>[
                          Hero(
                            tag: heroTag,
                            child: ProgressiveImage(
                              placeholder: AssetImage("assets/loading.png"),
                              thumbnail: Utils.fetchImage(controller.getImageElement(index), controller.imageType, true),
                              image: Utils.fetchImage(controller.getImageElement(index), controller.imageType),
                              width: 120,
                              height: 150,
                              fit: BoxFit.fitHeight,
                              fadeDuration: Duration(milliseconds: 150),
                              blur: 2,                      
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                            width: 120,
                            child: Text(controller.getNameElement(index), 
                              style: TextStyle(fontWeight: FontWeight.w700),
                              maxLines: 5,
                              softWrap: true,
                              textWidthBasis: TextWidthBasis.parent,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })
              ),
            ),
          );
        }
      )
    );
  }
}