import 'package:Videotheque/controllers/home_controller/HomeController.dart';
import 'package:Videotheque/Globals.dart';
import 'package:Videotheque/views/home_view/components/AskMailComponent.dart';
import 'package:Videotheque/views/home_view/components/LoadingComponent.dart';
import 'package:Videotheque/views/home_view/components/AppBarComponent.dart';
import 'package:Videotheque/views/home_view/components/AskForCoffeeComponent.dart';
import 'package:Videotheque/views/home_view/components/NoDataComponent.dart';
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
                    AnimatedCrossFade(
                      firstChild: LoadingComponent(), 
                      secondChild: controller.hasNoContent ? NoContentComponent() : Column(children: 
                        controller.infos..addAll([
                          Padding(padding: EdgeInsets.only(top: 10), child: Container()),
                          !controller.mailConfirmed ? AskMailComponent(controller.sendMailConfirm, controller.mailSended) : Container(),
                        ])..addAll(controller.carrousels)..add(AskForCoffeeComponent())
                      ),
                      crossFadeState: controller.isLoading ? CrossFadeState.showFirst : CrossFadeState.showSecond, 
                      duration: const Duration(milliseconds: 200)
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