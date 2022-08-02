import 'dart:ui';
import 'package:Videotheque/controllers/library/library_body_controller.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/views/library/component/no_data.dart';
import 'package:Videotheque/views/library/library_body_header_view.dart';
import 'package:Videotheque/views/library/library_sticky_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibraryBodyView extends StatefulWidget {
  final QueryTypes type;

  LibraryBodyView(this.type);

  @override
  State<StatefulWidget> createState() {
    return LibraryBodyViewState(type);
  }
}

class LibraryBodyViewState extends State<LibraryBodyView> with SingleTickerProviderStateMixin {
  final QueryTypes type;
  
  Color mainColor;
  Color splashColor;

  AnimationController rippleAnimationController;

  LibraryBodyViewState(this.type) {
    mainColor = Colors.grey[800];
    splashColor = GlobalsMessage.chipData[QueryTypes.values.indexOf(type)]["splash_color"];
  }

  @override
  void initState() {
    super.initState();
    rippleAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LibraryBodyController(context, type),
      child: Consumer<LibraryBodyController>(
        builder: (BuildContext context, controller, child) => !controller.displayLib ? Container(
          height: double.maxFinite,
          color: Colors.white,
          width: double.infinity,
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(GlobalsColor.darkGreen),
              backgroundColor: Colors.white,
            ),
          ),
        ) : CustomScrollView(
          controller: controller.sliverScrollController,
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: LibraryBodyHeaderView(mainColor, splashColor, type, controller, controller.optionElems)),
            controller.isLibrarydataEmpty ? SliverFillRemaining(child: NoDataComponent()) : LibraryStickyView(type, controller, rippleAnimationController)
          ]
        ),
      )
    );
  }
}
