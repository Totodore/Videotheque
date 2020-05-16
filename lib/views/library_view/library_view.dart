import 'dart:ui';

import 'package:Videotheque/controllers/library_controller/library_controller.dart';
import 'package:Videotheque/globals.dart';
import 'package:Videotheque/views/library_view/library_body_view.dart';
import 'package:Videotheque/views/library_view/library_header_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibraryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LibraryController>(
      create: (context) => LibraryController(context),
      child: Consumer<LibraryController>(builder: (context, controller, child) {
        return Container(
          color: GlobalsColor.darkGreen,
          child: SafeArea(
            child: Scaffold(
              body: Stack(
                children: <Widget>[
                  LibraryHeaderView(),
                  LibraryBodyView()
                ],
              )
            ),
          ),
        );
      }),
    );
  }
}
