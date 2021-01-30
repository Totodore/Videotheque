import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TrailerComponent extends StatelessWidget {

  final String ytKey;
  final String name;
  final Color color;

  const TrailerComponent(this.ytKey, this.name, this.color);

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(left: 75, right: 75, bottom: 30, top: 10),
      child: ActionChip(
        avatar: CircleAvatar(
          child: Icon(CommunityMaterialIcons.youtube, color: color, size: 25),
          backgroundColor: Colors.transparent,
        ),
        label: Text(name, style: TextStyle(fontSize: 20)),
        labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
        onPressed: () => launch("https://youtube.com/watch?v=$ytKey"),
      ),
    );
}