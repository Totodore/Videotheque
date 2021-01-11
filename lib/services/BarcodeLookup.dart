import 'package:Videotheque/Env.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart' show parse;

class BarcodeLookup {
  
  Future<String> getTitle(String barcode) async {
    Uri url = new Uri.https(environment.BARCODE_ORIGIN, barcode);
    Request req = new Request("GET", url);
    req.headers.addAll({
      "authority": environment.BARCODE_ORIGIN,
      "origin": environment.BARCODE_ORIGIN
    });
    final res = await req.send();
    if (res.statusCode == 200) {
      final html = parse(await res.stream.bytesToString());
      return html.querySelector(".detailtitle h2").innerHtml;
    }
    return null;
  }
}