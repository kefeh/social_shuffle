import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/features/game_loop/game_loop_notifier.dart';
import 'package:social_shuffle/features/summary/summary_screen.dart';

class VotingEngineScreen extends ConsumerStatefulWidget {
  const VotingEngineScreen({super.key});

  @override
  ConsumerState<VotingEngineScreen> createState() => _VotingEngineScreenState();
}

class _VotingEngineScreenState extends ConsumerState<VotingEngineScreen> {
  int _countdown = 3;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
        _startCountdown();
      } else {
        final gameLoopState = ref.read(gameLoopProvider);
        if (gameLoopState.isLastCard) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const SummaryScreen()),
          );
        } else {
          ref.read(gameLoopProvider.notifier).nextCard();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameLoopState = ref.watch(gameLoopProvider);
    final currentCard = gameLoopState.currentCard;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voting Engine'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              if (gameLoopState.isLastCard) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const SummaryScreen()),
                );
              } else {
                ref.read(gameLoopProvider.notifier).nextCard();
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Statement Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                currentCard.content,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 64),
            // Countdown Display
            Text(
              '$_countdown',
              style: const TextStyle(fontSize: 96, fontWeight: FontWeight.bold, color: Colors.amber),
            ),
          ],
        ),
      ),
    );
  }
}
