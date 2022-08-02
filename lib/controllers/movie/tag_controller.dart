
import 'package:Videotheque/globals.dart';
import 'package:flutter/material.dart';

class TagController extends ChangeNotifier {
  ElementsTypes type;
  List baseTags;
  List addedTags;
  BuildContext context;
  Function dispTagBottomSheet;
  
  TagController (this.context, this.type, this.baseTags, this.addedTags, this.dispTagBottomSheet);

  void onTagPressed(String tagId) {
    print("Tag pressed : $tagId");
  }

  String getTagId(int index) {   //Return map or String
    List globals = new List.from(baseTags)..addAll(addedTags);
    if (type == ElementsTypes.InfoTags)
      return "";
    else
      return globals[index]["id"].toString();
  }

  String getTagName(int index) {
    List globals = new List.from(baseTags)..addAll(addedTags);
    if (type == ElementsTypes.InfoTags)
      return globals[index];
    else
      return globals[index]["name"];
  }

  int getTagsLength() {
    List globals = new List.from(baseTags)..addAll(addedTags);
    return globals.length;
  }
  
  void onEditTagsTapped() {
    dispTagBottomSheet();
  }

  void updateTags(List newTags) {
    addedTags = newTags;
  }
}