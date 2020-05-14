import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonCarrouselComponent extends StatelessWidget {
  final int elementLength = 10;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: List.generate(elementLength, (int index) {
            return Card(
              elevation: 1,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                children: <Widget>[
                  SkeletonAnimation(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5), 
                        color: Colors.grey[300],
                      ),
                      width: 100,
                      height: 150,
                    ),
                  ),
                  SkeletonAnimation(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      width: 50, 
                      height: 13,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    )
                  ),
                ],
              ),
            );
          })
        ),
      ),
    );
  }
}