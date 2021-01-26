import 'package:Videotheque/components/divider_component.dart';
import 'package:Videotheque/components/skeleton_textline_component.dart';
import 'package:Videotheque/views/account_view/components/ButtonComponent.dart';
import 'package:Videotheque/views/account_view/components/SearchModeComponent.dart';
import 'package:Videotheque/views/account_view/components/StatsComponent.dart';
import 'package:Videotheque/views/person_view/person_view.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Videotheque/controllers/account_controller/AccountController.dart';
import 'package:Videotheque/Globals.dart';
class AccountView extends StatelessWidget {
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
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          borderOnForeground: true,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(width: 1, color: Colors.grey[300])),
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
                        SearchModeComponent(controller),
                        StatsComponent(controller),
                        ButtonComponent(controller.changeMail, CommunityMaterialIcons.account_edit, "Changer mon email"),
                        ButtonComponent(controller.changeName, CommunityMaterialIcons.account_edit, "Changer mon nom"),
                        ButtonComponent(controller.changePassword, CommunityMaterialIcons.account_edit, "Changer mon mot de passe"),
                        ButtonComponent(controller.logout, CommunityMaterialIcons.logout_variant, "Me déconnecter"),
                        DividerComponent(GlobalsColor.darkGreen),
                        ButtonComponent(controller.removeData, CommunityMaterialIcons.database_remove, "Supprimer mes données", PersonView.baseColor),
                        ButtonComponent(controller.removeAccount, CommunityMaterialIcons.account_remove, "Supprimer mon compte", PersonView.baseColor),
                        DividerComponent(GlobalsColor.darkGreen),
                        ButtonComponent(controller.foundBug, CommunityMaterialIcons.bug, "J'ai trouvé un bug !")
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