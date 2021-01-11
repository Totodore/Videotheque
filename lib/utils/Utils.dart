
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../globals.dart';

class Utils {
  static Future<Response> fetchData(url) {
    return get(url).timeout(Duration(seconds: 5));
  }

  static ImageProvider fetchImage(String image,ImageTypes type, [bool thumb = false]) {
    String url = "";
    switch (type) {
      case ImageTypes.Poster:
        url = thumb ? GlobalsData.thumbPosterSize : GlobalsData.posterSize;
        break;
      case ImageTypes.Backdrop:
        url = thumb ? GlobalsData.thumbBackdropSize : GlobalsData.backdropSize;
        break;
      case ImageTypes.Profile:
        url = thumb ? GlobalsData.thumbProfileSize : GlobalsData.profileSize;
        break;
      default: break;
    }
    try {
      if (image == null) throw Exception();
      url += image;
      return CachedNetworkImageProvider(url, scale: 1);
    } on Exception {
      return AssetImage("assets/NoImage.jpg");
    }
  }

  
  //Return False or the given id
  static Future<dynamic> checkOldAccount(String mail) async {
    Response res = await Utils.fetchData("https://app-videotheque.scriptis.fr/php/check_old_account.php?mail=$mail");
    if (res.statusCode != 200) {
      print("Error while fetching checkOldAccount");
      return false;
    }
    if (res.body.length > 0) return res.body;
    else return false;
  }
  
  static String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}