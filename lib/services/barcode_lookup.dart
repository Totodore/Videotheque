import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:Videotheque/env.dart';
import 'package:http/http.dart';

class BarcodeLookup {

  final regex = new RegExp(r'[\+\[\]=\-\(\)]', multiLine: false, caseSensitive: false);
  
  Future<String> getTitle(String barcode) async {
    Uri url = new Uri.https(environment.BARCODE_ORIGIN, p.join("api/v1/search"), { "query": barcode });
    print(url);
    Request req = new Request("GET", url);
    req.headers.addAll({
      "authority": environment.BARCODE_ORIGIN,
      "origin": environment.BARCODE_ORIGIN
    });
    final res = await req.send();
    if (res.statusCode == 200) {
      HashMap<String, dynamic> data = HashMap.from(jsonDecode(await res.stream.bytesToString())[0]);
      String title = "";
      for(final w in data["title"].split(" ")) {
        if (w.contains(regex))
          break;
        else
          title += " " + w;
      }
      return title;
    }
    else throw HttpException;
  }
}