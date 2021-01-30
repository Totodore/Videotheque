import 'package:flutter/material.dart';

class DividerComponent extends StatelessWidget {
  final String title;
  final Color mainColor;
  DividerComponent(this.mainColor, [this.title]);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Divider(
            color: this.mainColor,
            height: 2,
            thickness: 2,
          ),
        ),
        title != null ? Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              boxShadow: <BoxShadow>[BoxShadow(
                color: Colors.grey,
                spreadRadius: -1,
                blurRadius: 2,
                offset: Offset(0, 1.5)
              )],
              color: Colors.white,
            ),
            transform: Matrix4.translationValues(0, -20, 0),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Text(title,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15
              ),
            ),
          ),
        ) : Padding(padding: EdgeInsets.all(0))
      ]
    );
  }
}