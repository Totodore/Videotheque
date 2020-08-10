import 'package:Videotheque/globals.dart';
import 'package:Videotheque/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:provider/provider.dart';

import 'package:Videotheque/controllers/components/carrousel_controller.dart';

class CarrouselView extends StatelessWidget {

  QueryTypes type;
  List data;
  Function showEl;

  CarrouselView(this.type, this.data, [this.showEl]);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CarrouselController(context, type, data, showEl),
      child: Consumer<CarrouselController>(
        builder: (context, controller, child) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 13),
            child: SizedBox(
              height: 13+5+187.5,
              child: ListView.builder(
                // shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: controller.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  String heroTag = controller.heroTag;
                  return Padding(
                    padding: EdgeInsets.only(bottom: 13, top: 5, left: 6.5, right: 6.5),
                    child: RaisedButton(
                      elevation: 2,
                      clipBehavior: Clip.hardEdge,
                      onPressed: () {},
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
                          controller.isPeople ? Positioned(
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
                          ) : Padding(padding: EdgeInsets.zero),
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => controller.onElementTapped(index, heroTag),
                                splashColor: Colors.black.withOpacity(0.2),
                                highlightColor: Colors.black.withOpacity(0.1),
                                child: Container(height: double.maxFinite, width: double.maxFinite,),
                              )
                            )
                          )
                        ],
                      ),
                    ),
                  );
                }),
            ),
          );
        }
      )
    );
  }
}