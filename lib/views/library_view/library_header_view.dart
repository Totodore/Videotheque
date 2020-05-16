import 'dart:ui';

import 'package:Videotheque/controllers/library_controller/library_header_controller.dart';
import 'package:Videotheque/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibraryHeaderView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LibraryHeaderController>(
      create: (context) => LibraryHeaderController(),
      child: Consumer<LibraryHeaderController>(
        builder: (context, controller, child) {
          return PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  tileMode: TileMode.clamp,
                  colors: [
                    Colors.grey.withOpacity(1),
                    Colors.grey.withOpacity(0)
                  ]
                )
              ),
              height: controller.dispStartupAnimation ? kToolbarHeight : 0,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 32),
                    child: Text("Ma Vidéothèque", style: TextStyle(
                      color: GlobalsColor.darkGreen,
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                    ))
                  ),
                  Expanded(child: Container()),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 16),
                    child: IconButton(
                      icon: Icon(Icons.search, color: GlobalsColor.darkGreen, size: 30), 
                      onPressed: () => true
                    ),
                  )
                ],
              ),
            ),
          ));
        }
      ),
    );
  }
}