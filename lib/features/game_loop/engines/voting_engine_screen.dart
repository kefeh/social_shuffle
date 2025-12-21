import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/core/providers/game_provider.dart';
import 'package:social_shuffle/features/summary/summary_screen.dart';
import 'package:social_shuffle/shared/constants.dart';

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
          ref.read(gameLoopProvider.notifier).finishGame();
          final Color backgroundColor =
              engineBackgroundColor[ref
                  .read(gameLoopProvider)
                  .currentDeck
                  .gameEngineId] ??
              Color(0xFFA91079);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => SummaryScreen(color: backgroundColor),
            ),
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
      body: Container(
        alignment: Alignment.center,
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
                  Spacer(),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: .center,
                  mainAxisAlignment: .center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        currentCard.content,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 64),
                    // Countdown Display
                    Text(
                      '$_countdown',
                      style: const TextStyle(
                        fontSize: 96,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
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
