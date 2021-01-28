import 'package:Videotheque/components/divider_component.dart';
import 'package:Videotheque/components/skeleton_textline_component.dart';
import 'package:Videotheque/views/person_view/person_view.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Videotheque/controllers/account_controller/AccountController.dart';
import 'package:Videotheque/Globals.dart';
class AccountView extends StatelessWidget {
  final TextStyle textStyle = TextStyle(
    color: GlobalsColor.darkGreen,
    fontWeight: FontWeight.w500
  );
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AccountController>(
      create: (context) => AccountController(context),
      child: Consumer<AccountController>(
        builder: (context, controller, child) {
          controller.context = context;
          return Container(
            color: GlobalsColor.darkGreen,
            child: SafeArea(
              child: Scaffold(
                body: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                    child: Column(
                      children: [
                        Card(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                Icon(Icons.account_circle, size: 120),
                                Container(
                                  height: 100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 4.0),
                                            child: Icon(CommunityMaterialIcons.information_outline),
                                          ),
                                          AnimatedCrossFade(
                                            duration: Duration(milliseconds: 350),
                                            firstChild: Text(controller.name ?? "Erreur !", 
                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600), 
                                              textAlign: TextAlign.left,
                                            ),
                                            secondChild: SkeletonTextLineComponent(),
                                            crossFadeState: controller.accountDataState == States.Added ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 4.0),
                                            child: Icon(Icons.mail_outline),
                                          ),
                                          AnimatedCrossFade(
                                            duration: Duration(milliseconds: 350),
                                            firstChild: Text(controller.mail, 
                                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600), 
                                              textAlign: TextAlign.left, 
                                            ),
                                            secondChild: SkeletonTextLineComponent(),
                                            crossFadeState: controller.accountDataState == States.Added ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 4.0),
                                            child: Icon(CommunityMaterialIcons.account_clock_outline),
                                          ),
                                          AnimatedCrossFade(
                                            duration: Duration(milliseconds: 350),
                                            firstChild: Text(controller.accountCreation, 
                                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600), 
                                              textAlign: TextAlign.left
                                            ),
                                            secondChild: SkeletonTextLineComponent(),
                                            crossFadeState: controller.accountDataState == States.Added ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )    
                              ]
                            ),
                          ),
                        ),
                        Card(
                          child: ExpansionTile(
                            onExpansionChanged: controller.onDispStats,
                            title: Text("Statistiques", style: textStyle),
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
                        Card(
                          child: ListTile(
                            onTap: controller.changeMail,
                            leading: Icon(CommunityMaterialIcons.account_edit, color: GlobalsColor.darkGreen),
                            title: Text("Changer mon email", style: textStyle),
                            trailing: Icon(Icons.keyboard_arrow_right),
                          )
                        ),
                        Card(
                          child: ListTile(
                            onTap: controller.changeName,
                            leading: Icon(CommunityMaterialIcons.account_edit, color: GlobalsColor.darkGreen),
                            title: Text("Changer mon nom", style: textStyle),
                            trailing: Icon(Icons.keyboard_arrow_right),
                          )
                        ),
                        Card(
                          child: ListTile(
                            onTap: controller.changePassword,
                            leading: Icon(CommunityMaterialIcons.account_edit, color: GlobalsColor.darkGreen),
                            title: Text("Changer mon mot de passe", style: textStyle),
                            trailing: Icon(Icons.keyboard_arrow_right),
                          )
                        ),
                        Card(
                          child: ListTile(
                            onTap: controller.logout,
                            leading: Icon(CommunityMaterialIcons.logout_variant, color: GlobalsColor.darkGreen),
                            title: Text("Me déconnecter", style: textStyle),
                            trailing: Icon(Icons.keyboard_arrow_right),
                          )
                        ),
                        DividerComponent(GlobalsColor.darkGreen),
                        Card(
                          child: ListTile(
                            onTap: controller.removeData,
                            leading: Icon(CommunityMaterialIcons.database_remove, color: PersonView.baseColor),
                            title: Text("Supprimer mes données", style: TextStyle(fontWeight: FontWeight.w600, color: PersonView.baseColor)),
                            trailing: Icon(Icons.keyboard_arrow_right),
                          )
                        ),
                        Card(
                          child: ListTile(
                            onTap: controller.removeAccount,
                            leading: Icon(CommunityMaterialIcons.account_remove, color: PersonView.baseColor),
                            title: Text("Supprimer mon compte", style: TextStyle(fontWeight: FontWeight.w600, color: PersonView.baseColor)),
                            trailing: Icon(Icons.keyboard_arrow_right),
                          )
                        ),
                        DividerComponent(GlobalsColor.darkGreen),
                        Card(
                          child: ListTile(
                            onTap: controller.foundBug,
                            leading: Icon(CommunityMaterialIcons.bug, color: GlobalsColor.darkGreen),
                            title: Text("J'ai trouvé un bug !", style: textStyle),
                            trailing: Icon(Icons.keyboard_arrow_right),
                          )
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}