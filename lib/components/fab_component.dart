import 'package:Videotheque/components/CrossFadeComponent.dart';
import 'package:flutter/material.dart';

class FABComponent extends StatelessWidget {
  final bool added;
  final Color color;
  final void Function() onPressed;

  const FABComponent(this.added, this.color, this.onPressed);

  @override
  Widget build(BuildContext context) => FloatingActionButton(
    onPressed: onPressed,
    backgroundColor: color,
    elevation: 3,
    child: CrossFadeComponent(
      child1: Icon(Icons.add,
        color: Colors.white,
        size: 25,
      ),
      child2: Icon(Icons.done,
        color: Colors.white,
        size: 25,
      ),
      dispFirst: !added,
    ),
  );
}