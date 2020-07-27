import 'dart:ui';
import 'package:Videotheque/controllers/library_controller/library_body_controller.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/utils.dart';
import 'package:Videotheque/views/library_view/customSearchPainter.dart';
import 'package:Videotheque/views/library_view/library_body_header_view.dart';
import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class LibraryBodyView extends StatefulWidget {
  QueryTypes type;

  LibraryBodyView(this.type);

  @override
  State<StatefulWidget> createState() {
    return LibraryBodyViewState(type);
  }
}

class LibraryBodyViewState extends State<LibraryBodyView>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  QueryTypes type;
  Color mainColor;
  Color splashColor;

  AnimationController rippleAnimationController;

  LibraryBodyViewState(this.type) {
    mainColor = Colors.grey[800];
    splashColor = GlobalsMessage.chipData[QueryTypes.values.indexOf(type)]
        ["splash_color"];
  }

  @override
  void initState() {
    super.initState();
    rippleAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          LibraryBodyController(context, type, rippleAnimationController),
      child: Consumer<LibraryBodyController>(
          builder: (BuildContext context, controller, child) =>
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                crossFadeState: controller.displayLib
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                secondChild: Container(
                  height: double.infinity,
                  color: Colors.white,
                  width: double.infinity,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(GlobalsColor.darkGreen),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                firstChild: CustomScrollView(
                    controller: controller.sliverScrollController,
                    physics: BouncingScrollPhysics(),
                    slivers: [
                      LibraryBodyHeaderView(mainColor, splashColor, type, controller, controller.optionElems, controller.carrouselData),
                      
                    ]),
              )),
    );
  }
}
