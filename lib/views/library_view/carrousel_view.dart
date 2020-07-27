
import 'package:Videotheque/globals.dart';
import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:provider/provider.dart';
import 'package:Videotheque/utils/utils.dart';
import 'package:Videotheque/controllers/library_controller/carrousel_controller.dart';
class CarrouselView extends StatelessWidget {
  ElementsTypes type;
  List dataCarrousel;
  Color mainColor;
  Color splashColor;
  CarrouselView(this.type, this.dataCarrousel, this.mainColor, this.splashColor);
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CarrouselController(context, type, dataCarrousel),
      child: Consumer<CarrouselController>(
        builder: (context, controller, child) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 13),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 13,
                runSpacing: 5,
                runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.start,
                children: List.generate(controller.carrouselData.length, (int index) {
                  String heroTag = controller.heroTag;
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: RaisedButton(
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
                              width: 125,
                              height: 187.5,
                              fit: BoxFit.fitHeight,
                              fadeDuration: Duration(milliseconds: 150),
                              blur: 2,                      
                            ),
                          ),
                          controller.getElementType(index) == QueryTypes.person ? Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            height: 30,
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Text(controller.getNameElement(index) ?? "", style: TextStyle(
                                color: Colors.white,
                                fontSize: 13
                              ), maxLines: 1, overflow: TextOverflow.ellipsis,),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: FractionalOffset.bottomCenter,
                                  end: FractionalOffset.topCenter,
                                  colors: [
                                    Colors.black.withAlpha(150),
                                    Colors.black.withAlpha(0)
                                  ]
                                )
                              ),
                            ),
                          ) : Padding(padding: EdgeInsets.zero)
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