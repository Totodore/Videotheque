import 'package:Videotheque/views/TvView/TvView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'package:Videotheque/controllers/TvController/AddTagController.dart';
import 'package:Videotheque/components/DividerComponent.dart';

class AddTagView extends StatelessWidget {
  BuildContext context;
  List initialChips;
  BottomSheetController globalController;
  Function applyEdits;

  AddTagView(this.context, this.initialChips, this.applyEdits);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BottomSheetController>(
      create: (context) => BottomSheetController(context, initialChips, applyEdits),
      child: Consumer<BottomSheetController>(
        builder: (BuildContext context, BottomSheetController controller, Widget child) {
          globalController = controller;
          return AnimatedPadding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            duration: Duration(milliseconds: 350),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    width: MediaQuery.of(context).size.width,
                    child: Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.spaceEvenly,
                      spacing: 8,
                      runSpacing: 0,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: List<Widget>.generate(controller.chips.length, (int index) {
                        Map chip = controller.getChip(index);
                        return ActionChip(
                          label: Text(chip["name"]), 
                          onPressed: () => controller.removeChip(index),
                          avatar: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Icon(Icons.close, color: TvView.baseColor),
                          ),
                          labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                        );
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: DividerComponent(TvView.baseColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text("Rajoutez de nouveaux tags pour identifier vos séries ! (support, type, genre) : ",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      controller: controller.textController,
                      onChanged: (String input) => controller.onInputTag(input),
                      onSubmitted: (String input) => controller.onPressEnter(input),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: TvView.baseColor),
                        labelText: "Nouveaux Tags : ",
                        contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          borderSide: BorderSide(
                            color: TvView.baseColor,
                            width: 2,
                            style: BorderStyle.solid
                          )
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          borderSide: BorderSide(
                            color: TvView.baseColor,
                            width: 2,
                            style: BorderStyle.solid
                          ),
                        )
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        } 
      )
    );
  }
}