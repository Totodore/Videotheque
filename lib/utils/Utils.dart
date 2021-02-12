
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import '../Globals.dart';

class Utils {
  static Future<Response> fetchData(url) {
    return get(url).timeout(Duration(seconds: 30));
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
      return AssetImage("assets/img/loading.png");
    }
  }

  static String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}

Future<SheetController> showSnappingSheet(BuildContext context, Widget child) async {
  var controller = SheetController();
  var height = MediaQuery.of(context).size.height;
  await showSlidingBottomSheet(context, builder: (context) => SlidingSheetDialog(
    elevation: 8,
    cornerRadius: 16,
    backdropColor: Colors.black.withOpacity(0.2),
    snapSpec: SnapSpec(
      snap: true,
      snappings: [0, 0.8, (height - kToolbarHeight - 35) / height],
      positioning: SnapPositioning.relativeToAvailableSpace,
      initialSnap: 0.8
    ),
    duration: const Duration(milliseconds: 350),
    scrollSpec: ScrollSpec(
      physics: BouncingScrollPhysics()
    ),
    controller: controller,    
    builder: (context, state) => child
  ));
  return controller;
}