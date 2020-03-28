
import 'package:Videotheque/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AccountView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AccountViewState();
  }
}

class AccountViewState extends State<AccountView> {
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: GlobalsColor.darkGrey,
        ),
      ),
    );
  }
}