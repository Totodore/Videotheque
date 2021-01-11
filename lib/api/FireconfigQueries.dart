import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class FireconfigQueries {
  Future<String> get donationLink async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: !kReleaseMode));
    String donationLink = "";
    try {
      final defaults = <String, dynamic>{'donation_link': donationLink};
      await remoteConfig.setDefaults(defaults);

      await remoteConfig.fetch();
      await remoteConfig.activateFetched();

      if (donationLink != remoteConfig.getString('donation_link')) {
        return remoteConfig.getString("donation_link") ?? "";
      }
    } catch (e) {
      print(e.toString());
    }
    return donationLink;
  }

  Future<bool> get canTransferDb async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: !kReleaseMode));
    bool canTransferDb = false;
    try {
      final defaults = <String, dynamic>{'can_transfer_db': canTransferDb};
      await remoteConfig.setDefaults(defaults);

      await remoteConfig.fetch();
      await remoteConfig.activateFetched();

      if (canTransferDb != remoteConfig.getBool('can_transfer_db')) {
        return remoteConfig.getBool("can_transfer_db") ?? false;
      }
    } catch (e) {
      print(e.toString());
    }
    return canTransferDb;
  }
}