import 'package:Videotheque/components/divider_component.dart';
import 'package:Videotheque/controllers/home_controller/home_controller.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/views/home_view/components/TransfertDBComponent.dart';
import 'package:Videotheque/views/home_view/components/appBar_component.dart';
import 'package:Videotheque/views/home_view/components/askForCoffee_component.dart';
import 'package:Videotheque/views/home_view/components/noContentComponent.dart';
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
                    TransfertDBComponent(controller.confirmTransfertDB, controller.hideTransfertDB),
                    NoContentComponent(),
                    AskForCoffeeComponent(controller.onDonateClick)
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