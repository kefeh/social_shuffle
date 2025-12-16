import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/features/game_loop/game_loop_notifier.dart';
import 'package:social_shuffle/features/summary/summary_screen.dart';

class QuizEngineScreen extends ConsumerWidget {
  const QuizEngineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameLoopState = ref.watch(gameLoopProvider);
    final currentCard = gameLoopState.currentCard;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Engine'),
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
            // Timer Bar Placeholder
            LinearProgressIndicator(
              value: 0.5, // Placeholder value
              backgroundColor: Colors.grey[700],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
            ),
            const SizedBox(height: 32),
            // Question Text
            Text(
              currentCard.content,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            // Answer Buttons
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: currentCard.options != null
                    ? currentCard.options!
                        .asMap()
                        .entries
                        .map(
                          (entry) => ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Answer selected: ${entry.value} (Index: ${entry.key})')),
                              );
                              // TODO: Add actual answer validation logic
                            },
                            child: Text(entry.value),
                          ),
                        )
                        .toList()
                    : [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
