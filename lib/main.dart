import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:social_shuffle/core/models/card.dart';
import 'package:social_shuffle/core/models/deck.dart';
import 'package:social_shuffle/core/providers/main_provider.dart';
import 'package:social_shuffle/features/dashboard/dashboard_screen.dart';
import 'package:social_shuffle/features/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  Hive.registerAdapter(CardAdapter());
  Hive.registerAdapter(DeckAdapter());
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<void> appStartupState = ref.watch(appStartupProvider);
    return MaterialApp(
      title: 'Social Shuffle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.dark,
        ),
      ),
      home: appStartupState.when(
        loading: () => const SplashScreen(),
        error: (e, st) => AppStartupErrorWidget(
          message: e.toString(),
          onRetry: () => ref.invalidate(appStartupProvider),
        ),
        data: (_) => const DashboardScreen(),
      ),
    );
  }
}

class AppStartupErrorWidget extends StatelessWidget {
  const AppStartupErrorWidget({required this.message, super.key, this.onRetry});

  final String message;
  final void Function()? onRetry;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Social Shuffl Error Screen',
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark().copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.amber,
        brightness: Brightness.dark,
      ),
    ),
    home: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message),
            const SizedBox(height: 20),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    ),
  );
}
