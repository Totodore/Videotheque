import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';

class Preferences {

  SharedPreferences _pref;

  bool _newSearchUI = true;

  HashMap<String, bool> _dismissedInfos = HashMap<String, bool>();

  final String uiTag = "new_search_ui";

  bool loaded = false;

  Preferences() {
    init();
  }

  void init() async {
    _pref = await SharedPreferences.getInstance();
    _newSearchUI = _pref.getBool(uiTag) ?? true;
    loaded = true;
  }

  void toggleDismissed(String id, [bool value]) async {
    _dismissedInfos[id] = value ?? !(_dismissedInfos[id] ?? true);
    await _pref.setBool(id, _dismissedInfos[id]);
  }

  Future ensureLoaded() => Future.doWhile(() => !loaded);

  bool getDismissed(String id) => _dismissedInfos[id] ?? false;

  set newSearchUI(bool val) {
    _newSearchUI = val;
    _pref.setBool(uiTag, val);
  }

  bool get newSearchUI => _newSearchUI;
}