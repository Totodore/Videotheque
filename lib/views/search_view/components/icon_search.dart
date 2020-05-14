import 'package:Videotheque/controllers/search_controller/icon_search.dart';
import 'package:Videotheque/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class IconSearchView extends StatelessWidget {
  QueryTypes type;
  IconSearchView(this.type);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<IconSearchController>(
      create: (context) => IconSearchController(),
      child: Consumer<IconSearchController>(builder: (context, controller, child) {
        return AnimatedOpacity(
          opacity: controller.dispAnimation ? 1 : 0,
          duration: controller.animationDelay, 
          curve: Curves.ease,
          child: AnimatedContainer(
            duration: controller.animationDelay,
            curve: Curves.ease,
            transform: controller.dispAnimation ? Matrix4.translationValues(0, 0, 0) : Matrix4.translationValues(0, 50, 0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 65, bottom: 25), 
                  child: Center(
                    child: Icon(GlobalsMessage.chipData[QueryTypes.values.indexOf(type)]["icon"],
                      size: 100
                    )
                  )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(GlobalsMessage.defaultSearchMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        );
      })
    );
  }
}