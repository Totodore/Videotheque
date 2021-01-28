import 'package:Videotheque/models/FireconfigInfos.dart';
import 'package:Videotheque/services/Preferences.dart';
import 'package:Videotheque/utils/Singletons.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
class FireconfigQueries {

  List<FireconfigInfos> _infos = [];
  RemoteConfig _remoteConfig;
  Preferences _prefs = Singletons.instance<Preferences>();

  FireconfigQueries() {
    init();
  }

  Future<void> init() async {
    _remoteConfig = await RemoteConfig.instance;
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
        if (!(await _prefs.getDismissed(data?.id)))
          _infos.add(data);
      }
    }
  }

  bool get hasInfos => _infos.length > 0;
  int get infosLength => _infos.length;
  List<FireconfigInfos> get infos => _infos;
}