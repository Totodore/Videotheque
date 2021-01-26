import 'dart:ui';

import 'package:Videotheque/Globals.dart';
import 'package:Videotheque/controllers/account_controller/AccountController.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';



class SearchModeComponent extends StatelessWidget {

  final AccountController controller;
  SearchModeComponent(this.controller);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shadowColor: Colors.transparent,
      borderOnForeground: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(width: 1, color: Colors.grey[300])),
      child: Column(
        children: [
          ListTile(
            leading: Icon(CommunityMaterialIcons.movie_search, color: GlobalsColor.darkGreen),
            title: Text("Affichage des recherches", style: TextStyle(fontWeight: FontWeight.w600, color: GlobalsColor.darkGreen)),
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 10,
            childAspectRatio: 0.75,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            children: [
              OutlinedButton(onPressed: () => controller.newSearchDisplay = true,
                style: ButtonStyle(
                  side: MaterialStateProperty.all(BorderSide(color: controller.newSearchDisplay ? GlobalsColor.darkGreen : Colors.grey[300], width: 2)),
                  padding: MaterialStateProperty.all(const EdgeInsets.only(top: 20, left: 8, right: 8)),
                ),
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 0.80,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  physics: NeverScrollableScrollPhysics(),
                  children: List.generate(4, (cardIndex) => Card(elevation: 1, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: controller.gradients[cardIndex]
                        ),
                      )
                    )
                  ))
                )
              ),
              OutlinedButton(onPressed: () => controller.newSearchDisplay = false,
                style: ButtonStyle(
                  side: MaterialStateProperty.all(BorderSide(color: !controller.newSearchDisplay ? GlobalsColor.darkGreen : Colors.grey[300], width: 2)),
                  padding: MaterialStateProperty.all(const EdgeInsets.only(top: 5, left: 8, right: 8)),
                ),
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: List.generate(2, (listIndex) => Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(5))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5, top: 5),
                          child: Row(
                            children: [
                              Icon(Icons.movie, color: GlobalsColor.darkGreen, size: 17,),
                              Padding(padding: const EdgeInsets.only(left: 20)),
                              Container(height: 10, width: 90, decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5)
                              )),
                            ],
                          ),
                        ),
                        Container(
                          height: 80,
                          padding: const EdgeInsets.only(left: 5, top: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Card(elevation: 1, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                child: Container(
                                  padding: EdgeInsets.zero,
                                  height: 60,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                      colors: controller.gradients[listIndex]
                                    ),
                                  )
                                )
                              ),
                              Column(
                                children: List.generate(4, (index) => Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Container(height: 10, width: 60, decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(5)
                                  )),
                                )),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          color: GlobalsColor.darkGreen,
                          height: 1,
                          thickness: 1,
                        ),
                      ],
                    ),
                  ))
                )
              ),
            ],
          ),
        ],
      ),
    );
  }
}