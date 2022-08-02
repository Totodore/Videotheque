
import 'package:Videotheque/globals.dart';
import 'package:flutter/material.dart';

class TagController extends ChangeNotifier {
  ElementsTypes type;
  List tags;
  BuildContext context;
  Function dispTagBottomSheets;

  TagController (this.context, this.type, this.tags, this.dispTagBottomSheets);

  void onTagPressed(String tagId) {
    print("Tag pressed : $tagId");
  }

  String getTagId(int index) {   //Return map or String
    if (type == ElementsTypes.InfoTags)
      return "";
    else
      return tags[index]["id"];
  }

  String getTagName(int index) {
    if (type == ElementsTypes.InfoTags)
      return tags[index];
    else
      return tags[index]["name"];
  }

  int getTagsLength() {
    return tags.length;
  }
  
  void onEditTagsTapped() {
    dispTagBottomSheets();
  }

  void updateTags(List newTags) {
    tags = newTags;
  }  
}