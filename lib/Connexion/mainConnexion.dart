import 'package:flutter/material.dart';

import 'package:Videotheque/globals.dart';
import 'connexionForm.dart';
import 'subscriptionForm.dart';

class Connexion extends StatefulWidget {
  @override
  ConnexionState createState() {
    return ConnexionState();
  }
}
class ConnexionState extends State<Connexion> with SingleTickerProviderStateMixin {

  static TabController tabCtrl;

  @override
  void initState() {
    tabCtrl = TabController(vsync: this, length: 2, initialIndex: 0);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.subscriptions,
              color: GlobalsColor.darkGreen,
              size: 38,
            ),
            onPressed: null,
          ),
          centerTitle: true,
          title: Text(
            "Vidéothèque",
            style: TextStyle(
              fontFamily: "Aladin",
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: GlobalsColor.darkGreen
            )
          ),
          backgroundColor: GlobalsColor.lightGreen,
          bottom: TabBar(
            controller: tabCtrl,
            indicatorColor: GlobalsColor.lightGreen,
            indicatorWeight: 2,
            tabs: <Widget>[
              Tab(text: "CONNEXION"),
              Tab(text: "INSCRIPTION")
            ],
          ),
        ),
        body: TabBarView(
          controller: tabCtrl,
          children: <Widget>[
            ConnexionForm(),
            SubscriptionForm()
          ],
        ),
      ),
    );
  }
}