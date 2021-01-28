import 'package:Videotheque/models/FireconfigInfos.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
class FireconfigQueries {
  
  List<FireconfigInfos> _infos = [];
  RemoteConfig _remoteConfig;
  SharedPreferences _prefs;

  FireconfigQueries() {
    init();
  }

  Future<void> init() async {
    _remoteConfig = await RemoteConfig.instance;
    _prefs = await SharedPreferences.getInstance();
    await _remoteConfig.activateFetched();
    await _remoteConfig.fetch(expiration: const Duration(seconds: 0));
    await fetch();
  }


 /**
  * Get all info component and check if it is disabled in the sharedprefs;
  */
  Future<void> fetch() async {
    final config = _remoteConfig.getAll();
    for(final key in config.keys) {
      if (key.startsWith("info")) {
        var data = FireconfigInfos.fromString(config[key].asString());
        if (!(await _prefs.getBool(data?.id) ?? false))
          _infos.add(data);
      }
    }
  }

  bool get hasInfos => _infos.length > 0;
  int get infosLength => _infos.length;
  List<FireconfigInfos> get infos => _infos;
}