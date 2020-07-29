import 'package:Videotheque/controllers/library_controller/library_body_controller.dart';
import 'package:Videotheque/controllers/library_controller/library_sticky_controller.dart';
import 'package:Videotheque/controllers/library_controller/sortby_controller.dart';
import 'package:Videotheque/globals.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';

class SortByView extends StatelessWidget {
  LibraryStickyController parentController;
  SortOptions baseOption;
  SortByView(this.parentController, this.baseOption);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => SortByController(baseOption),
      child: Consumer<SortByController>(builder: (context, controller, child) => SimpleDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text("Trier par"),
          children: [
            Column(
              children: List.generate(SortOptions.values.length, (int index) => ListTile(
                title: Text(GlobalsMessage.sortOptions[SortOptions.values[index]], style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                )),
                leading: Radio<SortOptions>(
                  value: SortOptions.values[index], 
                  groupValue: controller.sortOption, 
                  onChanged: controller.onSortOptionUpdate,
                  activeColor: GlobalsColor.darkGreen,
                ),
                dense: true,
                onTap: () => controller.onSortOptionUpdate(SortOptions.values[index]),
              )),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: RaisedButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("VALIDER"),
                    ),
                    color: GlobalsColor.darkGreen,
                    highlightElevation: 3,
                    onPressed: () => parentController.closeDialogSort(controller.sortOption),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}