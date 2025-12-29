import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/core/providers/game_provider.dart';
import 'package:social_shuffle/features/game_loop/engines/flip_engine_screen.dart';
import 'package:social_shuffle/features/game_loop/engines/quiz_engine_screen.dart';
import 'package:social_shuffle/features/game_loop/engines/simple_flip_engine_screen.dart';
import 'package:social_shuffle/features/game_loop/engines/task_engine_screen.dart';
import 'package:social_shuffle/features/game_loop/engines/voting_engine_screen.dart';

class GameLoopScreen extends ConsumerStatefulWidget {
  const GameLoopScreen({super.key});

  @override
  ConsumerState<GameLoopScreen> createState() => _GameLoopScreenState();
}

class _GameLoopScreenState extends ConsumerState<GameLoopScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trackGameStart();
    });
  }

  Future<void> _trackGameStart() async {
    try {
      final deck = ref.read(gameLoopProvider).currentDeck;

      final docRef = FirebaseFirestore.instance
          .collection('deck_stats')
          .doc(deck.id);

      await docRef.set({
        'play_count': FieldValue.increment(1),
        'title': deck.title,
        'game_engine_id': deck.gameEngineId,
        'last_played_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint("tracked play for: ${deck.title}");
    } catch (e) {
      debugPrint("Error tracking game start: $e");
    }
  }

  Widget _getEngineWidget(String engineType) {
    switch (engineType) {
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
  Widget build(BuildContext context) {
    final gameLoopState = ref.watch(gameLoopProvider);

    return _getEngineWidget(gameLoopState.currentDeck.gameEngineType);
  }
}
