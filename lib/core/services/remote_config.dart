import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseRemoteConfigService {
  factory FirebaseRemoteConfigService() =>
      _instance ??= FirebaseRemoteConfigService._();
  FirebaseRemoteConfigService._()
      : _remoteConfig = FirebaseRemoteConfig.instance;
  static FirebaseRemoteConfigService? _instance;

  final FirebaseRemoteConfig _remoteConfig;

  String get appVersion => _remoteConfig.getString('app_version');
  String get onTesting => _remoteConfig.getString('on_testing');

  Future<void> initialize() async {
    await _setConfigSettings();
    await fetchAndActivate();
  }

  Future<void> _setConfigSettings() => _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(seconds: 1),
        ),
      );
  Future<void> fetchAndActivate() async {
    try {
      bool updated = await _remoteConfig.fetchAndActivate();

      if (updated) {
        debugPrint('The config has been updated.');
      } else {
        debugPrint('The config is not updated..');
      }
    } on Exception catch (_) {
      debugPrint('Fetch and activate failed');
    }
  }
}

final Provider<FirebaseRemoteConfigService> appConfigProvider =
    Provider((ref) => FirebaseRemoteConfigService());
