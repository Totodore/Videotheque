import 'package:Videotheque/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:progressive_image/progressive_image.dart';

class CompanyView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CompanyViewState();
  }
}

class CompanyViewState extends State<CompanyView> {

  Map _preLoadData = Map();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    String heroTag = "";

    if (GlobalsArgs.actualRoute == "/element/company/") {
      _preLoadData = GlobalsArgs.transfertArg[0];
      heroTag = GlobalsArgs.transfertArg[1];
    } else {
      GlobalsFunc.snackBar(context);
    }

    return SafeArea(  
      child: Scaffold(
        appBar: AppBar(
          title: Text(_preLoadData["name"]),
        ),
      )
    );
  }
}