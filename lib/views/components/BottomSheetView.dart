import 'package:Videotheque/controllers/components/BottomSheetController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class BottomSheetView extends StatelessWidget {

  final Widget back;
  final Widget sheet;
  final List<SnapPosition> positions;
  final void Function() onClose;

  final SnapPosition initialPosition = SnapPosition(positionFactor: 0, snappingDuration: const Duration(milliseconds: 200), snappingCurve: Curves.ease);
  BottomSheetController _controller;
  BottomSheetView({this.back, this.sheet, this.positions, this.onClose});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => BottomSheetController(context, this.positions, this.onClose),
    child: Consumer<BottomSheetController>(
      builder: (context, controller, child) {
        this._controller = controller;
        return SnappingSheet(
          snappingSheetController: controller.sheetController,
          lockOverflowDrag: true,
          initSnapPosition: this.initialPosition,
          snapPositions: this.positions,
          child: this.back,
          sheetBelow: SnappingSheetContent(
            draggable: true,
            heightBehavior: SnappingSheetHeight.fit(),
            child: sheet
          ),
          grabbingHeight: controller.show ? 35 : 0,
          grabbing: this._grabSection(context),
          onMove: (double offset) => controller.dragPosition = offset,
        );
      }
    ),
  );

  
  Widget _grabSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(
          blurRadius: 20.0,
          color: Colors.black.withOpacity(0.2),
        )],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 200.0,
            height: 5.0,
            margin: EdgeInsets.only(top: 15.0),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(Radius.circular(5.0))
            ),
          ),
        ],
      ),
    );
  }

  void toggleSheet() => _controller.toggleSheet();
  set positionIndex(int index) => _controller.positionIndex = index;
}