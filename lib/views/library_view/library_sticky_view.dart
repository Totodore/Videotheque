import 'package:Videotheque/controllers/library_controller/library_sticky_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';

class LibraryStickyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => LibraryStickyController(),
          child: Consumer<LibraryStickyController>(
            builder: (context, controller, child) => SliverStickyHeaderBuilder(
              controller: controller.libraryHeaderController,
              builder: (BuildContext context,
                      SliverStickyHeaderState state) =>
                  Stack(
                    overflow: Overflow.visible,
                    children: [
                      !controller.dispSearchBar
                          ? AppBar(
                              backgroundColor: state.isPinned
                                  ? Colors.white.withOpacity(0.4)
                                  : Colors.transparent,
                              // leading: Padding(padding: EdgeInsets.zero),
                              automaticallyImplyLeading: false,
                              elevation: state.isPinned ? 4 : 0,
                              titleSpacing: 0,
                              title: ClipRect(
                                child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 8, sigmaY: 8),
                                    child: AppBar(
                                      backgroundColor: Colors.white
                                          .withOpacity(0.4),
                                      // leading: Padding(padding: EdgeInsets.zero),
                                      elevation: 0,
                                      automaticallyImplyLeading:
                                          false,

                                      title: Text(
                                          GlobalsMessage.chipData[
                                                  QueryTypes.values
                                                      .indexOf(
                                                          type)]
                                              ["library_appBar"],
                                          style: TextStyle(
                                              color: Colors
                                                  .grey[800])),
                                      actions: <Widget>[
                                        GestureDetector(
                                            child: IconButton(
                                                icon: Icon(
                                                    Icons.search,
                                                    color: Colors
                                                        .grey[800],
                                                    size: 30)),
                                            onTapUp: controller
                                                .onSearchButtonClick),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(
                                                    right: 5)),
                                        IconButton(
                                            icon: Icon(
                                                Icons.filter_list,
                                                color: Colors
                                                    .grey[800],
                                                size: 30),
                                            onPressed: controller
                                                .onSortButtonClick),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(
                                                    right: 16))
                                      ],
                                    )),
                              ),
                            )
                          : Container(),
                      AnimatedBuilder(
                          animation: controller.rippleAnimation,
                          builder: (context, child) {
                            return CustomPaint(
                                painter: CustomSearchPainter(
                                    containerHeight: kToolbarHeight,
                                    center: controller
                                            .startRippleAnimation ??
                                        Offset(0, 0),
                                    context: context,
                                    radius: controller
                                            .rippleAnimation.value *
                                        MediaQuery.of(context)
                                            .size
                                            .width));
                          }),
                      controller.dispSearchBar
                          ? AppBar(
                              backgroundColor: Colors.white,
                              leading: Icon(
                                Icons.search,
                                color: GlobalsColor.darkGreen,
                              ),
                              title: TextField(
                                decoration: InputDecoration(
                                    hintText:
                                        "Recherchez un élément"),
                              ),
                              actions: [
                                IconButton(
                                  icon: Icon(Icons.close,
                                      color:
                                          GlobalsColor.darkGreen),
                                  onPressed:
                                      controller.onCloseSearchClick,
                                )
                              ],
                            )
                          : Container()
                    ],
                  ),
              sliver: SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0, vertical: 10),
                sliver: SliverGrid.count(
                    crossAxisCount: 2,
                    // maxCrossAxisExtent: MediaQuery.of(context).size.width/2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.67,
                    children: List.generate(
                        controller.libraryLength, (index) {
                      String heroTag = controller.heroTag;
                      return InkWell(
                        child: RaisedButton(
                          elevation: 2,
                          clipBehavior: Clip.hardEdge,
                          onPressed: () => controller
                              .onElementTapped(index, heroTag),
                          highlightElevation: 4,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(5)),
                          child: Stack(
                            children: <Widget>[
                              Hero(
                                tag: heroTag,
                                child: ProgressiveImage(
                                  placeholder: AssetImage(
                                      "assets/loading.png"),
                                  thumbnail: Utils.fetchImage(
                                      controller
                                          .getImageElement(index),
                                      controller
                                          .getImageType(index),
                                      true),
                                  image: Utils.fetchImage(
                                      controller
                                          .getImageElement(index),
                                      controller
                                          .getImageType(index)),
                                  width: 400,
                                  height: 600,
                                  fit: BoxFit.fitHeight,
                                  fadeDuration:
                                      Duration(milliseconds: 150),
                                  blur: 2,
                                ),
                              ),
                              controller.getElementType(index) ==
                                      QueryTypes.person
                                  ? Positioned(
                                      bottom: 0,
                                      right: 0,
                                      left: 0,
                                      height: 40,
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                            controller
                                                    .getNameElement(
                                                        index) ??
                                                "",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17),
                                            maxLines: 1),
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin:
                                                    FractionalOffset
                                                        .bottomCenter,
                                                end: FractionalOffset.topCenter,
                                                colors: [
                                              Colors.black
                                                  .withAlpha(160),
                                              Colors.black
                                                  .withAlpha(0)
                                            ])),
                                      ),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.zero)
                            ],
                          ),
                        ),
                      );
                    })),
              )),
          ),
    )
  }
}