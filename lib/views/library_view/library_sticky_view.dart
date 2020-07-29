import 'dart:ui';

import 'package:Videotheque/controllers/library_controller/library_body_controller.dart';
import 'package:Videotheque/controllers/library_controller/library_sticky_controller.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/utils/utils.dart';
import 'package:Videotheque/views/library_view/customSearchPainter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:provider/provider.dart';

class LibraryStickyView extends StatelessWidget {
  final QueryTypes _type;
  final LibraryBodyController _parentController;
  final AnimationController _rippleAnimationController;

  LibraryStickyView(this._type, this._parentController, this._rippleAnimationController);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => LibraryStickyController(context, _type, _parentController, _rippleAnimationController),
          child: Consumer<LibraryStickyController>(
            builder: (context, controller, child) => SliverStickyHeaderBuilder(
              key: controller.stickyHeaderKey,
              controller: controller.libraryHeaderController,
              builder: (BuildContext context, SliverStickyHeaderState state) => Stack(
                overflow: Overflow.visible,
                children: [
                  !controller.dispSearchBar ? AppBar(
                    backgroundColor: state.isPinned ? Colors.white.withOpacity(0.4) : Colors.transparent,
                    automaticallyImplyLeading: false,
                    elevation: state.isPinned ? 4 : 0,
                    titleSpacing: 0,
                    title: ClipRect(
                      child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: AppBar(
                            backgroundColor: Colors.white.withOpacity(0.4),
                            elevation: 0,
                            automaticallyImplyLeading:false,
                            title: Text(GlobalsMessage.chipData[QueryTypes.values.indexOf(_type)]["library_appBar"],
                              style: TextStyle(color: Colors.grey[800])
                            ),
                            actions: <Widget>[
                              GestureDetector(
                                child: Icon(Icons.search,
                                  color: Colors.grey[800],
                                  size: 30
                                ),
                                onTapUp: controller.onSearchButtonClick
                              ),
                              Padding(padding: EdgeInsets.only(right: 5)),
                              IconButton(
                                icon: Icon(Icons.filter_list,
                                  color: Colors.grey[800],
                                  size: 30
                                ),
                                onPressed: controller.onSortButtonClick
                              ),
                              Padding(padding: EdgeInsets.only(right: 16))
                            ],
                          )),
                    ),
                  ) : Container(),
                  AnimatedBuilder(
                    animation: controller.rippleAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: CustomSearchPainter(
                          containerHeight: kToolbarHeight,
                          center: controller.startRippleAnimation ?? Offset(0, 0),
                          context: context,
                          radius: controller.rippleAnimation.value *MediaQuery.of(context).size.width
                        )
                      );
                    }
                  ),
                  controller.dispSearchBar ? AppBar(
                    titleSpacing: 0,
                    backgroundColor: Colors.white,
                    automaticallyImplyLeading: false,
                    title: Padding(
                      padding: const EdgeInsets.only(top:3.0),
                      child: TextField(
                        focusNode: controller.focusSearchBar,
                        onChanged: controller.onSearchLibrary,
                        onSubmitted: (String val) => controller.onCloseSearchClick(),
                        cursorColor: GlobalsColor.darkGreen,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Recherchez par titre, nom, tag...",
                          hintStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: GlobalsColor.darkGreen,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: GlobalsColor.darkGreen,
                          size: 30,
                        ),
                        onPressed: controller.onCloseSearchClick,
                      )
                    ],
                  ) : Container()
                ],
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
                              thumbnail: Utils.fetchImage(controller.getImageElement(index), controller.getImageType(index),true),
                              image: Utils.fetchImage(controller.getImageElement(index), controller.getImageType(index)),
                              width: 400,
                              height: 600,
                              fit: BoxFit.fitHeight,
                              fadeDuration: const Duration(milliseconds: 150),
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
                              child: Text(
                                controller.getNameElement(index) ?? "",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17
                                ),
                                maxLines: 1
                              ),
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
                      );
                    })
                  ),
            )),
        ),
    );
  }
}