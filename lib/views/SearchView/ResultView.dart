
import 'package:Videotheque/controllers/SearchController/ResultController.dart';
import 'package:Videotheque/Globals.dart';
import 'package:Videotheque/models/api/ApiSearchModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class ResultSearchView extends StatelessWidget {
  final QueryTypes type;
  final ApiSearchModel data;
  final bool newDisplayResult;

  const ResultSearchView(this.type, this.data, this.newDisplayResult);

  @override
  Widget build(BuildContext context) {
    print(newDisplayResult);
    return ChangeNotifierProvider<ResultSearchController>(
      create: (context) => ResultSearchController(type, context, data, ),
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
                newDisplayResult ? getImgWidgets(controller) : getCardWidgets(controller)
              ],
            );
          }),
        );
      })
    );
  }

  Widget getCardWidgets(ResultSearchController controller) => SliverList(
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
  );

  Widget getImgWidgets(ResultSearchController controller) => SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
    sliver: SliverGrid.count(
      crossAxisCount: 2,
      // maxCrossAxisExtent: MediaQuery.of(context).size.width/2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 0.67,
      children: List.generate(controller.data.results.length, (index) => AnimationConfiguration.staggeredGrid(
        columnCount: 2,
        position: index,
        duration: const Duration(milliseconds: 350),
        child: SlideAnimation(
          verticalOffset: 25,
          child: FadeInAnimation(
            child: controller.getImg(index)
          ),
        ),
      ))
    ),
  );
}