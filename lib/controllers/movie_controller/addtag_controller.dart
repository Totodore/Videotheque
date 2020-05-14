import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddTagController extends ChangeNotifier {
  BuildContext context;
  List chips;
  TextEditingController textController;
  FocusNode textFocus;
  Function applyEdits;

  AddTagController(this.context, this.chips, this.applyEdits) {
    textController = TextEditingController();
    textFocus = FocusNode(canRequestFocus: true);
  }

  Map getChip(int index) => chips[index];

  void removeChip(int index) {
    chips.removeAt(index);
    notifyListeners();
  }

  void onInputTag(String input, [bool forceInput = false]) {
    if (input.endsWith(" ") || forceInput) {
      textController.clear();
        if (input.length > 1) {
        chips.add({
          'name': input.trim(),
          'id': Uuid().v1()
        });
      }
      if (!forceInput)
        notifyListeners();
    }
  }

  void onPressEnter(String input) {
    onInputTag(input, true);
    Navigator.of(context).pop();
    applyEdits();
  }
}

