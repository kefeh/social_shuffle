import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/core/providers/game_provider.dart';
import 'package:social_shuffle/features/summary/summary_screen.dart';
import 'package:social_shuffle/shared/constants.dart';

class TaskEngineScreen extends ConsumerWidget {
  const TaskEngineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameLoopState = ref.watch(gameLoopProvider);
    final currentCard = gameLoopState.currentCard;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              engineBackgroundColor[gameLoopState.currentDeck.gameEngineId] ??
                  Color(0xFFA91079),
              Color(0xFF2E0249),
              Color(0xFF570A57),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(child: BackButton()),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Text(
                        gameLoopState.currentDeck.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        if (gameLoopState.isLastCard) {
                          final Color backgroundColor =
                              engineBackgroundColor[ref
                                  .read(gameLoopProvider)
                                  .currentDeck
                                  .gameEngineId] ??
                              Color(0xFFA91079);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) =>
                                  SummaryScreen(color: backgroundColor),
                            ),
                          );
                        } else {
                          ref.read(gameLoopProvider.notifier).nextCard();
                        }
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: .center,
                  crossAxisAlignment: .center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        currentCard.meta?['timer']?.toString() ?? '00:00',
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Big Text (Target Word)
                    Text(
                      currentCard.content,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                      ),
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
                              const SnackBar(
                                content: Text('Pass button pressed!'),
                              ),
                            );
                          },
                          child: const Text('Pass'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Got it! button pressed!'),
                              ),
                            );
                          },
                          child: const Text('Got it!'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
