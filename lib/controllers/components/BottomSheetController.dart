import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class BottomSheetController extends ChangeNotifier {
  final BuildContext context;
  final SnappingSheetController sheetController = SnappingSheetController();
  final List<SnapPosition> _positions;
  final void Function() _onClose;
  
  int _positionIndex = 0;
  bool _show = false;

  BottomSheetController(this.context, this._positions, this._onClose);

  SnapPosition get position => _positions[_positionIndex];
  bool get show => _show;

  set positionIndex(int index) {
    if (index < _positions.length && index >= 0) {
      _positionIndex = index;
      notifyListeners();
    }
  }
  set dragPosition(double offset) {
    if (offset == 0) {
      this._onClose();
      _show = false;
      notifyListeners();
    }
    print(_show);
  }

  void toggleSheet() {
    _show = !_show;
    positionIndex = _show ? 1 : 0;
    notifyListeners();
  }
}