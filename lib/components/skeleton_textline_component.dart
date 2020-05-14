import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonTextLineComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SkeletonAnimation(
      child: Container(
        width: 150,
        height: 17,
        decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.all(Radius.circular(10)))
      )
    );
  }
}