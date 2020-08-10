import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonCardComponent extends StatelessWidget {
  final Color mainColor;

  SkeletonCardComponent(this.mainColor);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      borderOnForeground: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
      margin: EdgeInsets.all(6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile( //Skeleton for title
            title: SkeletonAnimation(child: Container(
              width: MediaQuery.of(context).size.width*0.7, 
              height: 25, 
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
            )),
          ),
          Container(
            padding: EdgeInsets.only(right: 7, left: 7, bottom: 7, top:0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[ //Skeleton for image
                SkeletonAnimation(
                  child: Container(
                    width: 100,
                    height: 150,
                    color: Colors.grey[300],
                  ),
                ),
                Padding(  //Skeleton for text
                  padding: EdgeInsets.only(left: 20, top: 8),
                  child: Column(children: List.generate(7, (int index) {
                    return Padding(padding: EdgeInsets.only(bottom: 7), child: Theme(
                      data: ThemeData(backgroundColor: Colors.grey[300]),
                      child: SkeletonAnimation(
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.55, 
                          height: 13,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                        )
                      )
                    ));
                  })),
                ),
              ]
            ),
          ),
          Divider(
            color: mainColor,
            height: 2,
            thickness: 2,
          ),
        ],
      ),
    );
  }
}