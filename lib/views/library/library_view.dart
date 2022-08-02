import 'dart:ui';

import 'package:Videotheque/controllers/library/library_controller.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/views/library/library_body_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibraryView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LibraryViewStates();    
  }
}
class LibraryViewStates extends State<LibraryView> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin{
  TabController resultsPageController;
  @override
  void initState() { 
    super.initState();
    resultsPageController = TabController(vsync: this, length: QueryTypes.values.length, initialIndex: 0);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider<LibraryController>(
      create: (context) => LibraryController(context),
      child: Consumer<LibraryController>(builder: (context, controller, child) {
        resultsPageController.addListener(() {
            controller.updateTabIndex(resultsPageController.index);
        });
        return Scaffold(
          extendBody: true,
          appBar: PreferredSize(
            child: Container(color: GlobalsColor.darkGreen), preferredSize: Size.fromHeight(0)),
            body: SafeArea(
              child: DefaultTabController(
                length: controller.tabLength,
                child: Scaffold(
                  appBar: AppBar(
                    titleSpacing: 0,
                    automaticallyImplyLeading: false,
                    title: Material(
                      child: Theme(
                        data: ThemeData(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          accentColor: GlobalsColor.darkGreenDisabled
                        ),
                        child: TabBar(
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide.none
                        ),
                        controller: resultsPageController,
                        isScrollable: true,
                        labelPadding: EdgeInsets.symmetric(horizontal: 8),
                        tabs: List<Widget>.generate(controller.tabLength, (int index) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              splashColor: GlobalsMessage.chipData[index]["splash_color"]
                            ),
                              child: ChoiceChip(
                                labelStyle: TextStyle(
                                  color: GlobalsMessage.chipData[index]["color"],
                                  fontWeight: FontWeight.w600
                                ),
                                selectedColor: GlobalsMessage.chipData[index]["selected_color"],
                                label: Row(children: <Widget>[
                                  Icon(GlobalsMessage.chipData[index]["icon"],
                                    color: GlobalsMessage.chipData[index]["color"]
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 10)
                                  ),
                                  Text(GlobalsMessage.chipData[index]["keyword"])
                                ]),
                                selected: controller.isChipSelected(index),
                                onSelected: (bool selected) {
                                  if (selected)
                                    resultsPageController.animateTo(index);
                                },
                              )
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                  body: TabBarView(
                    physics: BouncingScrollPhysics(),
                    controller: resultsPageController,
                    children: List.generate(QueryTypes.values.length, (index) => LibraryBodyView(QueryTypes.values[index]))
                  )
                )
              ),
            ),
        );
      }),
    );
  }
}
