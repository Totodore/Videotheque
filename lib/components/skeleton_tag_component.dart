
import 'package:Videotheque/Globals.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonTagComponent extends StatelessWidget {
  int tagLength = 3;
  SkeletonTagComponent(int newTagLength) {
    tagLength = newTagLength;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.spaceEvenly,
        spacing: 6,
        runSpacing: 0,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: List<Widget>.generate(tagLength, (int index) {
          return SkeletonAnimation(
            child: Chip(
              padding: EdgeInsets.all(0),
              labelPadding: EdgeInsets.all(0),
              backgroundColor: Colors.transparent,
              shadowColor: GlobalsColor.darkGreenDisabled,
              label: Container(width: 150, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.all(Radius.circular(50))))
            )
          );
        }),
      ),
    ); 
  }
}