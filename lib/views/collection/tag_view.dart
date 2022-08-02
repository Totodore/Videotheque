import 'package:Videotheque/globals.dart';
import 'package:Videotheque/views/collection/collection_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Videotheque/controllers/collection/tag_controller.dart';
import 'package:Videotheque/controllers/collection/collection_controller.dart';

class TagView extends StatelessWidget {
  ElementsTypes type;
  List tags;
  CollectionController parentController;
  Function dispTagBottomSheet;
  TagView(this.type, this.tags, this.dispTagBottomSheet);
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TagController>(
      create: (context) => TagController(context, type, tags, dispTagBottomSheet),
      child: Consumer<TagController>(
        builder: (context, controller, child) {
          controller.updateTags(tags);
          return Container(
            padding: const EdgeInsets.only(top: 5, bottom: 0),
            width: MediaQuery.of(context).size.width,
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceEvenly,
              spacing: 8,
              runSpacing: 0,
              crossAxisAlignment: WrapCrossAlignment.end,  //Si c'est les genreTags on rajoute le bouton pour les éditer
              children: List<Widget>.generate(type == ElementsTypes.GenreTags ? controller.getTagsLength()+1 : controller.getTagsLength(), (int index) {
                if (controller.getTagsLength() == 0 && type == ElementsTypes.GenreTags) return ActionChip(
                  labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  label: Text("Ajouter des tags"),
                  onPressed: () => controller.onEditTagsTapped(),
                  elevation: 2,
                  pressElevation: 4,
                  backgroundColor: CollectionView.baseColor,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  avatar: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(Icons.edit, color: Colors.white)
                  ),
                );
                else if (controller.getTagsLength() == index) return ActionChip( 
                  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                  label: Icon(Icons.edit, color: CollectionView.baseColor),
                  onPressed: () => controller.onEditTagsTapped(),
                  shape: StadiumBorder(side: BorderSide(color: CollectionView.baseColor, width: 1.5)),
                );
                else return ActionChip(
                  label: Text(controller.getTagName(index)),
                  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                  avatar: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(type == ElementsTypes.GenreTags ? Icons.label_outline : Icons.info_outline, color: CollectionView.baseColor),
                  ),
                  onPressed: () => controller.onTagPressed(controller.getTagId(index)),
                  
                );
              }),
            ),
          );
        }
      )
    );
  }
}