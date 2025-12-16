import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/core/models/deck.dart';
import 'package:social_shuffle/features/game_loop/engines/flip_engine_screen.dart';
import 'package:social_shuffle/features/game_loop/engines/quiz_engine_screen.dart';
import 'package:social_shuffle/features/game_loop/engines/task_engine_screen.dart';
import 'package:social_shuffle/features/game_loop/engines/voting_engine_screen.dart';
import 'package:social_shuffle/features/game_loop/game_loop_notifier.dart';

class GameLoopScreen extends ConsumerStatefulWidget {
  final Deck deck;

  const GameLoopScreen({super.key, required this.deck});

  @override
  ConsumerState<GameLoopScreen> createState() => _GameLoopScreenState();
}

class _GameLoopScreenState extends ConsumerState<GameLoopScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize the game loop provider with the selected deck
    ref.read(gameLoopProvider.notifier).initializeGame(widget.deck);
  }

  Widget _getEngineWidget(String engineId) {
    switch (engineId) {
      case 'quiz':
        return const QuizEngineScreen();
      case 'flip':
        return const FlipEngineScreen();
      case 'task':
        return const TaskEngineScreen();
      case 'voting':
        return const VotingEngineScreen();
      default:
        return const QuizEngineScreen(); // Fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameLoopState = ref.watch(gameLoopProvider);

    return _getEngineWidget(gameLoopState.currentDeck.gameEngineId);
  }
}