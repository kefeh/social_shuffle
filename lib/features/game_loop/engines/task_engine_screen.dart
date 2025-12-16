import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/features/game_loop/game_loop_notifier.dart';
import 'package:social_shuffle/features/summary/summary_screen.dart';

class TaskEngineScreen extends ConsumerWidget {
  const TaskEngineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameLoopState = ref.watch(gameLoopProvider);
    final currentCard = gameLoopState.currentCard;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Engine'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              if (gameLoopState.isLastCard) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const SummaryScreen(),
                  ),
                );
              } else {
                ref.read(gameLoopProvider.notifier).nextCard();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Timer Placeholder
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                currentCard.meta?['timer']?.toString() ?? '00:00',
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            const SizedBox(height: 32),
            // Big Text (Target Word)
            Text(
              currentCard.content,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Subtext (Forbidden words/Rules)
            Text(
              'Forbidden: ${currentCard.meta?['forbidden_words']?.join(', ') ?? 'N/A'}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey[400]),
            ),
            const SizedBox(height: 32),
            // Placeholder for Gyroscope/Button controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pass button pressed!')),
                    );
                  },
                  child: const Text('Pass'),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Got it! button pressed!')),
                    );
                  },
                  child: const Text('Got it!'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
