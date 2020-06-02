import 'package:Videotheque/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';


class IconSearchView extends StatelessWidget {
  QueryTypes type;
  IconSearchView(this.type);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AnimationConfiguration.staggeredList(
          position: 0,
          duration: const Duration(milliseconds: 350),
          child: SlideAnimation(
            verticalOffset: 100,
            child: FadeInAnimation(
              child: Padding(
                padding: EdgeInsets.only(top: 65, bottom: 25), 
                child: Center(
                  child: Icon(GlobalsMessage.chipData[QueryTypes.values.indexOf(type)]["icon"],
                    size: 100
                  )
                )
              ),
            ),
          ),
        ),
        AnimationConfiguration.staggeredList(
          position: 1,
          duration: const Duration(milliseconds: 350),
          child: SlideAnimation(
            verticalOffset: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(GlobalsMessage.defaultSearchMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
          ),
        )
      ],
    );
  }
}