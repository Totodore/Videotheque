import 'package:Videotheque/Globals.dart';
import 'package:Videotheque/components/divider_component.dart';
import 'package:Videotheque/controllers/account_controller/AccountController.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';

class StatsComponent extends StatelessWidget {

  final AccountController controller;

  const StatsComponent(this.controller);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
    child: OutlineButton(
      padding: const EdgeInsets.all(0),
      highlightedBorderColor: GlobalsColor.darkGreenDisabled.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      onPressed: () {},
      color: Colors.white,
      splashColor: GlobalsColor.darkGreenDisabled.withOpacity(0.1),
      highlightColor: Colors.grey.withOpacity(0.2),
      child: ExpansionTile(
        onExpansionChanged: controller.onDispStats,
        title: Text("Statistiques", style: TextStyle(
          color: GlobalsColor.darkGreen,
          fontWeight: FontWeight.w500
        )),
        leading: Icon(CommunityMaterialIcons.chart_bell_curve, color: GlobalsColor.darkGreen),
        trailing: AnimatedCrossFade(
          firstChild: AnimatedCrossFade(
            firstChild: Icon(Icons.keyboard_arrow_down), 
            secondChild: Icon(Icons.keyboard_arrow_up),
            duration: Duration(milliseconds: 300),
            crossFadeState: controller.dispStats ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          ),
          secondChild: Padding(
            padding: const EdgeInsets.all(5.0),
            child: SizedBox(
              width: 23,
              height: 23,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(GlobalsColor.darkGreen),
              ),
            ),
          ), 
          crossFadeState: controller.statsStates == States.Added ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: Duration(milliseconds: 350),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 30,
              children: [
                Column(
                  children: [
                    Text("${controller.statNumberMovies}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    Icon(Icons.movie, size: 30),
                  ],
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.grey
                ),
                Column(
                  children: [
                    Text("${controller.statNumberPeople}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    Icon(Icons.person, size: 30),
                  ],
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.grey,
                ),
                Column(
                  children: [
                    Text("${controller.statNumberTv}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    Icon(Icons.tv, size: 30),
                  ],
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.grey
                ),
                Column(
                  children: [
                    Text("${controller.statNumberCollection}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    Icon(Icons.subscriptions, size: 30),
                  ],
                ),
              ],
            ),
          ),
          DividerComponent(GlobalsColor.darkGreen),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 30,
              children: [
                Column(
                  children: [
                    Text("${controller.statNumberFav}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    Icon(Icons.favorite_border, size: 30),
                  ],
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.grey,                               
                ),
                Column(
                  children: [
                    Text("${controller.statNumberToSee}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    Icon(CommunityMaterialIcons.eye_off_outline, size: 30),
                  ],
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.grey,                               
                ),
                Column(
                  children: [
                    Text("${controller.statNumberSeen}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    Icon(CommunityMaterialIcons.eye_check, size: 30),
                  ],
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.grey
                ),
                Column(
                  children: [
                    Text("${controller.statNumberTags}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    Icon(Icons.label_outline, size: 30),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}