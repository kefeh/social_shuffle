import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/features/game_loop/game_loop_notifier.dart';
import 'package:social_shuffle/features/summary/summary_screen.dart';

class FlipEngineScreen extends ConsumerStatefulWidget {
  const FlipEngineScreen({super.key});

  @override
  ConsumerState<FlipEngineScreen> createState() => _FlipEngineScreenState();
}

class _FlipEngineScreenState extends ConsumerState<FlipEngineScreen> {
  bool _showFront = true;

  void _toggleCard() {
    setState(() {
      _showFront = !_showFront;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Card flipped!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameLoopState = ref.watch(gameLoopProvider);
    final currentCard = gameLoopState.currentCard;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flip Engine'),
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
                setState(() {
                  _showFront = true; // Reset card to front for next card
                });
              }
            },
          ),
        ],
      ),
      body: Center(
        child: GestureDetector(
          onTap: _toggleCard,
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.blueGrey,
            child: SizedBox(
              width: 300,
              height: 400,
              child: Center(
                child: Text(
                  currentCard.content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 32, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
