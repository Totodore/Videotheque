import 'package:Videotheque/controllers/library_controller/library_body_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class LibraryBodyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LibraryBodyController(context),
      child: Consumer<LibraryBodyController>(builder: (BuildContext context, controller, child) => Container(

      )),
    );
  }
}