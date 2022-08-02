import 'package:flutter/material.dart';

class CrossFadeComponent extends StatelessWidget {
  final Widget child1;
  final Widget child2;
  Duration _duration;
  final bool dispFirst;

  CrossFadeComponent({this.child1, this.child2, int ms = 200, this.dispFirst}) {
    _duration = Duration(milliseconds: ms);
  }

  @override
  Widget build(BuildContext context) => AnimatedCrossFade(
      firstChild: child1,
      secondChild: child2,
      crossFadeState: dispFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: _duration,
  );
}