import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class BottomSheetController extends ChangeNotifier {
  final BuildContext context;
  final SnappingSheetController sheetController = SnappingSheetController();
  final void Function() _onClose;
  
  bool _show = false;
  bool _opening = false;

  Widget _sheet;

  BottomSheetController(this.context, this._onClose);

  SnapPosition get position => sheetController.currentSnapPosition;
  bool get show => _show;

  set positionIndex(int index) {
    sheetController.snapToPosition(sheetController.snapPositions[index]);
  }
  set dragPosition(double offset) {
    if (offset == 0 && !_opening) {
      this._onClose();
      _show = false;
      notifyListeners();
    } else _show = true;
  }
  set sheet(Widget sheet) {
    _sheet = sheet;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 300), () {
      _show = true; 
      notifyListeners();
    });
  }

  Widget get sheet => _sheet ?? Container();
}