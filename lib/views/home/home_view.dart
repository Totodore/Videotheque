import 'package:Videotheque/components/cross_fade_component.dart';
import 'package:Videotheque/controllers/home/home_controller.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/views/home/components/ask_mail_component.dart';
import 'package:Videotheque/views/home/components/Loading_component.dart';
import 'package:Videotheque/views/home/components/app_bar_component.dart';
import 'package:Videotheque/views/home/components/ask_for_coffee_component.dart';
import 'package:Videotheque/views/home/components/no_data_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => HomeController(context),
      child: Consumer<HomeController>(
        builder: (context, controller, child) => Container(
          color: GlobalsColor.darkGreen,
          child: SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: Column(children: [
                    AppBarComponent(),
                    CrossFadeComponent(
                      child1: LoadingComponent(),
                      child2: controller.hasNoContent ? NoContentComponent() : Column(children: 
                        controller.infos..addAll([
                          Padding(padding: EdgeInsets.only(top: 10), child: Container()),
                          !controller.mailConfirmed ? AskMailComponent(controller.sendMailConfirm, controller.mailSended) : Container(),
                        ])..addAll(controller.carrousels)..add(AskForCoffeeComponent()),
                      ),
                      dispFirst: controller.isLoading,
                    ),
                  ]),
                ),
              ),
            ),
          ),
        )
      ),
    );
  }
}