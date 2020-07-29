import 'package:Videotheque/api/fireconfigQueries.dart';
import 'package:Videotheque/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends ChangeNotifier {
  final BuildContext _context;

  HomeController(this._context);


  void confirmTransfertDB() {

  }

  void hideTransfertDB() {

  }


  void onDonateClick() async {
    String donateLink = await FireconfigQueries.donationLink;
    if (donateLink == null || donateLink.length == 0) {
      GlobalsFunc.snackBar(_context, "Erreur ! Vérifiez votre connexion internet");
      return;
    }
    print(donateLink);
    launch(donateLink);
  }
}