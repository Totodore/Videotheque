import 'package:Videotheque/Globals.dart';
import 'package:Videotheque/views/tv_view/TvView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Videotheque/controllers/movie_controller/tag_controller.dart';
import 'package:Videotheque/controllers/movie_controller/movie_controller.dart';

class TagView extends StatelessWidget {
  ElementsTypes type;
  List tags;
  List addedTags;
  MovieController parentController;
  bool isAdded;
  Function onAddTagTapped;
  TagView(this.type, this.tags, this.addedTags, this.isAdded, this.onAddTagTapped);
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TagController>(
      create: (context) => TagController(context, type, tags, addedTags, onAddTagTapped),
      child: Consumer<TagController>(
        builder: (context, controller, child) {
          controller.updateTags(addedTags);
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceEvenly,
              spacing: 6,
              runSpacing: 0,
              crossAxisAlignment: WrapCrossAlignment.center,  //Si c'est les genreTags on rajoute le bouton pour les éditer
              children: List<Widget>.generate(type == ElementsTypes.GenreTags && isAdded ? controller.getTagsLength()+1 : controller.getTagsLength(), (int index) {
                if (controller.getTagsLength() == index) 
                  return ActionChip(
                    labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                    label: Icon(Icons.edit, color: TvView.baseColor),
                    onPressed: () => controller.onEditTagsTapped(),
                    shape: StadiumBorder(side: BorderSide(color: TvView.baseColor, width: 1.5)),
                  ); else
                  return ActionChip(
                    label: Text(controller.getTagName(index)),
                    labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                    avatar: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Icon(type == ElementsTypes.GenreTags ? Icons.label_outline : Icons.info_outline, color: TvView.baseColor),
                    ),
                    onPressed: () => controller.onTagPressed(controller.getTagId(index))
                  );
              }),
            ),
          );
        }
      )
    );
  }
}