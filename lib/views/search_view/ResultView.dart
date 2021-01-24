
import 'package:Videotheque/controllers/search_controller/ResultController.dart';
import 'package:Videotheque/Globals.dart';
import 'package:Videotheque/models/api/ApiSearchModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class ResultSearchView extends StatelessWidget {
  QueryTypes type;
  ApiSearchModel data;
  ResultSearchView(this.type, this.data);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ResultSearchController>(
      create: (context) => ResultSearchController(type, context, data),
      child: Consumer<ResultSearchController>(builder: (context, controller, child) {
        return SafeArea(
          top: false,
          bottom: false,
          child: Builder(builder: (BuildContext context) {
            return CustomScrollView(
              physics: BouncingScrollPhysics(),
              key: PageStorageKey<String>(type.toString()),
              slivers: <Widget>[
                SliverOverlapInjector(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 350),
                        child: SlideAnimation(
                          verticalOffset: 25,
                          child: FadeInAnimation(
                            child: controller.getCard(index)
                          ),
                        ),
                      );
                    },
                    childCount: controller.data.results.length,
                  ),
                  // itemExtent: 300,
                )
              ],
            );
          }),
        );
      })
    );
  }
}