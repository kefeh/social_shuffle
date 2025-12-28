import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/core/providers/game_provider.dart';
import 'package:social_shuffle/features/game_loop/engines/flip_engine_screen.dart';
import 'package:social_shuffle/features/game_loop/engines/quiz_engine_screen.dart';
import 'package:social_shuffle/features/game_loop/engines/simple_flip_engine_screen.dart';
import 'package:social_shuffle/features/game_loop/engines/task_engine_screen.dart';
import 'package:social_shuffle/features/game_loop/engines/voting_engine_screen.dart';

class GameLoopScreen extends ConsumerWidget {
  const GameLoopScreen({super.key});

  Widget _getEngineWidget(String engineId) {
    switch (engineId) {
      case 'quiz':
        return const QuizEngineScreen();
      case 'flip':
        return const FlipEngineScreen();
      case 'simple_flip':
        return const SimpleFlipEngineScreen();
      case 'task':
        return const TaskEngineScreen();
      case 'voting':
        return const VotingEngineScreen();
      default:
        return const QuizEngineScreen();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameLoopState = ref.watch(gameLoopProvider);

    return _getEngineWidget(gameLoopState.currentDeck.gameEngineType);
  }
}
