
import 'package:Videotheque/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Account extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AccountState();
  }
}

class AccountState extends State<Account> {
  
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