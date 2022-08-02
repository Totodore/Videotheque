import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonCarrouselComponent extends StatelessWidget {
  final int elementLength = 10;
  @override
  Widget build(BuildContext context) {
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
          children: List.generate(elementLength, (int index) {
            return Card(
              elevation: 1,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: SkeletonAnimation(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), 
                    color: Colors.grey[300],
                  ),
                  width: 125,
                  height: 187.5,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}