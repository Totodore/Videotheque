import 'package:Videotheque/globals.dart';
import 'package:flutter/cupertino.dart';

class CardController extends ChangeNotifier {
  QueryTypes type;
  BuildContext context;
  Map data;

  States cardState = States.Nothing;

  CardController(this.context, this.type, this.data);

  void knownElementTapped(String type, Map data) {
    String route = "/element/$type/";
    GlobalsArgs.isFromLibrary = true;
    GlobalsArgs.actualRoute = route;
    GlobalsArgs.transfertArg = List.from([data, ""]);
    Navigator.pushNamed(context, route, arguments: data);
  }

  void elementTapped(Map data, String heroId) {
    String route = "/element/${GlobalsMessage.chipData[QueryTypes.values.indexOf(type)]["route"]}/";
    GlobalsArgs.isFromLibrary = true;
    GlobalsArgs.actualRoute = route;
    GlobalsArgs.transfertArg = List.from([data, heroId]);
    Navigator.pushNamed(context, route, arguments: data);
  }
}