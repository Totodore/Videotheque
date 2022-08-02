import 'package:Videotheque/globals.dart';
import 'package:flutter/material.dart';

class ButtonComponent extends StatelessWidget {

  final Function onClick;
  final IconData icon;
  final String text;
  final Color color;

  const ButtonComponent(this.onClick, this.icon, this.text, [this.color = GlobalsColor.darkGreen]);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
    child: OutlineButton(
      padding: const EdgeInsets.all(0),
      highlightedBorderColor: GlobalsColor.darkGreenDisabled.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      onPressed: onClick,
      color: Colors.white,
      splashColor: GlobalsColor.darkGreenDisabled.withOpacity(0.1),
      highlightColor: Colors.grey.withOpacity(0.2),
      child: ListTile(
        tileColor: Colors.transparent,
        leading: Icon(icon, color: color),
        title: Text(text, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
        trailing: Icon(Icons.keyboard_arrow_right),
      ),
    ),
  );
}