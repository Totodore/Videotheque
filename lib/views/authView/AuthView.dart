import 'package:Videotheque/components/divider_component.dart';
import 'package:Videotheque/Globals.dart';
import 'package:Videotheque/views/app_view.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Videotheque/controllers/AuthController/AuthController.dart';


class AuthView extends StatelessWidget {
  AppView mainView;

  AuthView(this.mainView);

  final OutlineInputBorder inputBorder = new OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(3)),
    borderSide: BorderSide(
      color: GlobalsColor.darkGreen,
      width: 2,
      style: BorderStyle.solid
    )
  );
  final OutlineInputBorder inputDisabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(3)),
    borderSide: BorderSide(
      color: GlobalsColor.darkGreenDisabled,
      width: 1.5,
      style: BorderStyle.solid
    )
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthController>(
      create: (context) => AuthController(context, mainView),
      child: Consumer<AuthController>(
        builder: (context, controller, child) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Container(
              color: GlobalsColor.darkGreen,
              child: SafeArea(
                child: Scaffold(
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(150.2),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(top: 20, left: 10),
                              child: Image(
                                image: AssetImage("assets/icon/launcher_iconV2.png"),
                                width: MediaQuery.of(context).size.width/4,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0, left: 10),
                              child: Text("Vidéothèque", style: TextStyle(
                                  fontWeight: FontWeight.w700, 
                                  fontSize: 50,
                                  fontFamily: 'Aladin',
                                  color: Colors.black,
                                  letterSpacing: 1,
                                ), 
                                textAlign: TextAlign.center,
                              ),
                            )
                          ]
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: DividerComponent(GlobalsColor.darkGreen),
                        ),
                      ],
                    ),
                  ),
                  body: Builder(
                    builder: (context) {
                      controller.scaffoldContext = context;
                      return Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          child: Form(
                            key: controller.formKey,
                            child: Column(
                              children: [
                                Padding(padding: const EdgeInsets.only(top: 15), child: Container()),
                                ToggleButtons(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/11, vertical: 5),
                                      child: Text("Inscription"),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/11, vertical: 5),
                                      child: Text("Connexion"),
                                    ),
                                  ], 
                                  textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                                  isSelected: controller.selectedToggles,
                                  onPressed: controller.onToggleButtonsPressed,
                                  splashColor: GlobalsColor.darkGreenDisabled,
                                  fillColor: GlobalsColor.fadedGreen,
                                  selectedColor: Colors.black,
                                  borderRadius: BorderRadius.circular(50),
                                  borderColor: GlobalsColor.darkGreenDisabled,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller: controller.emailController,
                                    decoration: InputDecoration(
                                      errorText: controller.emailError,
                                      border: inputBorder,
                                      focusedBorder: inputBorder,
                                      disabledBorder: inputDisabledBorder,
                                      labelStyle: TextStyle(color: GlobalsColor.darkGreen),
                                      labelText: "Email",
                                      contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 0),
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Veuillez entrer un email valide";
                                      }
                                      return null;
                                    },
                                    enabled: !controller.pendingTransfer,
                                  ),
                                ),
                                AnimatedCrossFade(
                                  duration: controller.crossFadeDuration,
                                  firstChild: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                                    child:  TextFormField(
                                      enabled: !controller.pendingTransfer,
                                      controller: controller.nameController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        disabledBorder: inputDisabledBorder,
                                        border: inputBorder,
                                        focusedBorder: inputBorder,
                                        labelStyle: TextStyle(color: GlobalsColor.darkGreen),
                                        focusColor: GlobalsColor.darkGreen,
                                        labelText: "Nom",
                                        contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 0),
                                      ),
                                    ),
                                  ),
                                  secondChild: Container(padding: EdgeInsets.zero),
                                  crossFadeState: controller.registerSelected ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                                  child:  TextFormField(
                                    enabled: !controller.pendingTransfer,
                                    obscureText: !controller.showPassword,
                                    controller: controller.passwdController,
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: InputDecoration(
                                      border: inputBorder,
                                      focusedBorder: inputBorder,
                                      disabledBorder: inputDisabledBorder,
                                      labelStyle: TextStyle(color: GlobalsColor.darkGreen),
                                      focusColor: GlobalsColor.darkGreen,
                                      labelText: "Mot de passe",
                                      errorText: controller.passwdError,
                                      contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 0),
                                      suffixIcon: IconButton(
                                        icon: Icon(controller.showPassword ? Icons.visibility : Icons.visibility_off),
                                        color: GlobalsColor.darkGreen,
                                        onPressed: controller.onShowPasswordPressed,
                                      ),
                                    ),
                                    validator: controller.passwdValidator,
                                  ),
                                ),
                                AnimatedCrossFade(
                                  duration: controller.crossFadeDuration,
                                  firstChild: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                                    child:  TextFormField(
                                      enabled: !controller.pendingTransfer,
                                      obscureText: !controller.showConfirmPassword,
                                      controller: controller.passwdConfirmController,
                                      keyboardType: TextInputType.visiblePassword,
                                      decoration: InputDecoration(
                                        border: inputBorder,
                                        focusedBorder: inputBorder,
                                        disabledBorder: inputDisabledBorder,
                                        labelStyle: TextStyle(color: GlobalsColor.darkGreen),
                                        focusColor: GlobalsColor.darkGreen,
                                        labelText: "Confirmer le mot de passe",
                                        contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 0),
                                        suffixIcon: IconButton(
                                          icon: Icon(controller.showConfirmPassword ? Icons.visibility : Icons.visibility_off),
                                          color: GlobalsColor.darkGreen,
                                          onPressed: controller.onShowConfirmPasswordPressed,
                                        ),
                                      ),
                                    ),
                                  ),
                                  secondChild: Container(padding: EdgeInsets.zero),
                                  crossFadeState: controller.registerSelected ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 25.0),
                                  child: Stack(
                                    fit: StackFit.passthrough,
                                    overflow: Overflow.clip,
                                    children: <Widget>[
                                      Visibility(
                                        visible: controller.pendingTransfer,
                                        child: Padding(padding: EdgeInsets.only(left: 3, top: 3, right: 0, bottom: 0), child: SizedBox(
                                          width: 85,
                                          height: 85,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 5,
                                            valueColor: AlwaysStoppedAnimation<Color>(GlobalsColor.darkGreen)
                                          ),
                                        )),
                                      ),
                                      RawMaterialButton(
                                        padding: EdgeInsets.all(25),
                                        shape: CircleBorder(side: BorderSide(color: controller.pendingTransfer ? GlobalsColor.darkGreenDisabled : GlobalsColor.darkGreen, width: 2)),
                                        enableFeedback: controller.pendingTransfer,
                                        child: Icon(Icons.arrow_forward, color: controller.pendingTransfer ? GlobalsColor.darkGreenDisabled : GlobalsColor.darkGreen, size: 40),
                                        splashColor: GlobalsColor.fadedGreen,
                                        onPressed: !controller.pendingTransfer ? controller.onConfirmButtonPress : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                  bottomNavigationBar: ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton.icon(
                        icon: Icon(CommunityMaterialIcons.google, color: GlobalsColor.darkGreen),
                        label: Text("Me connecter avec Google", 
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        onPressed: controller.onConnectGooglePressed,
                        color: Colors.white,
                        textColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        elevation: 1,
                        highlightElevation: 2,
                      ),
                      // FlatButton(
                      //   child: Text("Je ne souhaite pas utiliser de compte", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                      //   onPressed: !controller.pendingTransfer ? controller.onNoAccountPressed : null,
                      //   textColor: Colors.black,
                      // )
                    ],
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