import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';

class Preferences {

  SharedPreferences _pref;

  bool _newSearchUI = true;

  HashMap<String, bool> _dismissedInfos;

  Preferences() {
    init();
  }

  void init() async {
    _pref = await SharedPreferences.getInstance();
    _newSearchUI = _pref.getBool("new_search_ui") ?? true;
  }

  void toggleDismissed(String id, [bool value]) {
    _dismissedInfos[id] = value ?? !(_dismissedInfos[id] ?? true);
    _pref.setBool(id, _dismissedInfos[id]);
  }

  bool getDismissed(String id) => _dismissedInfos[id] ?? false;

  set newSearchUI(bool val) {
    _newSearchUI = val;
    _pref.setBool("new_search_ui", val);
  }

  bool get newSearchUI => _newSearchUI;
}