import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class NoImgComponent extends StatelessWidget {

  final String text;
  final double height;
  final double width;
  final double fontSize;

  const NoImgComponent(this.text, [this.width = 400, this.height = 600, this.fontSize = 18]);

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: List.generate(2, (index) => RandomColor().randomColor())
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Center(
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8)
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(text ?? "", textAlign: TextAlign.center, style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: fontSize,
                  color: Colors.orange[50]
                )),
              ),
            )
          ),
        ),
      ),
    ),
  );
}