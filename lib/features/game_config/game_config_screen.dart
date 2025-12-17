import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/core/providers/game_provider.dart';
import 'package:social_shuffle/features/game_loop/game_loop_screen.dart';

class GameConfigScreen extends ConsumerStatefulWidget {
  const GameConfigScreen({super.key});

  @override
  ConsumerState<GameConfigScreen> createState() => _GameConfigScreenState();
}

class _GameConfigScreenState extends ConsumerState<GameConfigScreen> {
  bool _isTimerEnabled = true;
  bool _isSoundEnabled = true;

  @override
  Widget build(BuildContext context) {
    final deck = ref.watch(currentDeckProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Configuration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Enable Timer'),
              value: _isTimerEnabled,
              onChanged: (value) {
                setState(() {
                  _isTimerEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Enable Sound'),
              value: _isSoundEnabled,
              onChanged: (value) {
                setState(() {
                  _isSoundEnabled = value;
                });
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (deck != null) {
                  // TODO: Pass the config to the game loop
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const GameLoopScreen(),
                    ),
                  );
                }
              },
              child: const Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }
}
