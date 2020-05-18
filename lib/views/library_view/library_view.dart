import 'dart:ui';

import 'package:Videotheque/controllers/library_controller/library_controller.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/views/library_view/library_body_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibraryView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LibraryViewStates();    
  }
}
class LibraryViewStates extends State<LibraryView> with SingleTickerProviderStateMixin {
  TabController resultsPageController;
  @override
  void initState() { 
    super.initState();
    resultsPageController = TabController(vsync: this, length: QueryTypes.values.length, initialIndex: 0);
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LibraryController>(
      create: (context) => LibraryController(context),
      child: Consumer<LibraryController>(builder: (context, controller, child) {
        resultsPageController.addListener(() {
            controller.updateTabIndex(resultsPageController.index);
        });
        return DefaultTabController(
            length: controller.tabLength,
            child: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool isInnerBoxScrolled) {
                  controller.updateIsInnerBoxScrolled = isInnerBoxScrolled;
                  return <Widget>[
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                      sliver: SliverSafeArea(
                        top: false,
                        sliver: SliverAppBar(
                          elevation: 3,
                          forceElevated: isInnerBoxScrolled,
                          floating: true,
                          pinned: true,
                          snap: true,
                          backgroundColor: GlobalsColor.darkGreen,
                          expandedHeight: 2 * kToolbarHeight - 5,
                          title: Text("Ma Vidéothèque"),
                          actions: <Widget>[
                            IconButton(
                              icon: Icon(Icons.search, size: 30),
                              onPressed: () => true,
                            )
                          ],
                          bottom: PreferredSize(
                            preferredSize: Size.fromHeight(kToolbarHeight - 6),
                            child: Material(
                              child: Theme(
                                data: ThemeData(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  accentColor:
                                  GlobalsColor.darkGreenDisabled
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
                                          Text(GlobalsMessage.chipData[index]["name"])
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
                        ),
                      ),
                    )
                  ];
                },
                body: TabBarView(
                  controller: resultsPageController,
                  children: List<Widget>.generate(controller.tabLength, (int index) {
                    Widget returner;
                    QueryTypes type = QueryTypes.values[index];
                    // switch(controller.loadedViews[type]) {
                    //   case States.Nothing: returner = IconSearchView(QueryTypes.values[index]); break;
                    //   case States.Error: returner = IconErrorView();  break;
                    //   case States.Empty: returner = IconNothingView();  break;
                    //   case States.Loading: returner = LoadingView(GlobalsMessage.chipData[index]["color"]);  break;
                    //   case States.Added: returner = ResultSearchView(type, controller.getDataResults(type)); break; 
                    // }
                    return LibraryBodyView();
                  })
                )
              )
            );
      }),
    );
  }
}
