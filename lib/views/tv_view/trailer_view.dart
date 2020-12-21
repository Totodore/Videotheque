import 'package:Videotheque/views/tv_view/tv_view.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TrailerView extends StatelessWidget {
  String ytKey;

  TrailerView(String key) {
    ytKey = key;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 75, right: 75, bottom: 30, top: 10),
      child: ActionChip(
        avatar: CircleAvatar(
          child: Icon(CommunityMaterialIcons.youtube, color: TvView.baseColor, size: 25,),
          backgroundColor: Colors.transparent,
        ),
        label: Text("Trailer de la saison", style: TextStyle(fontSize: 20)), 
        labelStyle: TextStyle(color: TvView.baseColor, fontWeight: FontWeight.w600),
        onPressed: () => launch("https://youtube.com/watch?v=$ytKey"),
      ),
    );
  }
}