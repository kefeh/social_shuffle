import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/core/services/package_info.dart';
import 'package:social_shuffle/core/services/remote_config.dart';

final appStartupProvider = FutureProvider((ref) async {
  await ref.watch(appInfoProvider).initialize();
  await ref.watch(appConfigProvider).initialize();
});
