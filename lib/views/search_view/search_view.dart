import 'dart:async';

import 'package:Videotheque/controllers/search_controller/search_controller.dart';
import 'package:Videotheque/views/search_view/components/loading.dart';
import 'package:Videotheque/views/search_view/result_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Videotheque/globals.dart';
import 'package:Videotheque/views/search_view/components/icon_error.dart';
import 'package:Videotheque/views/search_view/components/icon_search.dart';
import 'package:Videotheque/views/search_view/components/icon_nothing.dart';

class SearchView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchViewState();
  }
}

class SearchViewState extends State<SearchView> with TickerProviderStateMixin {
  TabController resultsPageController;
  @override
  void initState() { 
    super.initState();
    resultsPageController = TabController(vsync: this, length: QueryTypes.values.length, initialIndex: 0);
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchController>(
      create: (context) => SearchController(),
      child: Consumer<SearchController>(builder: (context, controller, child) {
        resultsPageController.addListener(() {
            controller.updateTabIndex(resultsPageController.index);
        });
        return DefaultTabController(
            length: controller.tabLength,
            child: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool isInnerBoxScrolled) {
                  controller.updateIsInnerBoxScrolled(isInnerBoxScrolled);
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
                          centerTitle: true,
                          expandedHeight: 2 * kToolbarHeight - 5,
                          title: TextField(
                            focusNode: controller.focusNode,
                            controller: controller.searchInputController,
                            textInputAction: TextInputAction.search,
                            cursorColor: Color(0xFFebebeb),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: -6),
                              hintText: "Nouvelle recherche",
                              focusColor: GlobalsColor.darkGreen,
                              border: InputBorder.none,
                              focusedBorder: null,
                              hintStyle: TextStyle(color: Color(0xFFebebeb).withAlpha(180))),
                              style: TextStyle(
                                color: Color(0xFFebebeb),
                                fontSize: 18.5,
                                fontWeight: FontWeight.w400
                              ),
                            onSubmitted: controller.searchQuery,
                            onChanged: controller.onchangeQuery,
                          ),
                          leading: AnimatedSwitcher(
                            child: controller.searchInputController.text.length > 0
                              ? IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: Icon(
                                    Icons.close,
                                    size: 28,
                                  ),
                                  onPressed: controller.clearView,
                                )
                              : IconButton(
                                  padding: EdgeInsets.all(0),
                                  icon: Icon(
                                    Icons.search,
                                    size: 28,
                                  ),
                                  onPressed: null,
                                ),
                            duration: Duration(milliseconds: 300)
                          ),
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
                    switch(controller.loadedViews[type]) {
                      case States.Nothing: returner = IconSearchView(QueryTypes.values[index]); break;
                      case States.Error: returner = IconErrorView();  break;
                      case States.Empty: returner = IconNothingView();  break;
                      case States.Loading: returner = LoadingView(GlobalsMessage.chipData[index]["color"]);  break;
                      case States.Added: returner = ResultSearchView(type, controller.getDataResults(type)); break; 
                    }
                    return returner;
                  })
                )
              )
            );
      }),
    );
  }
}
