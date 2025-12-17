import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:social_shuffle/core/models/deck.dart';
import 'package:social_shuffle/features/game_loop/game_loop_notifier.dart';

final currentDeckProvider = StateProvider<Deck?>((ref) => null);

final gameLoopProvider = NotifierProvider<GameLoopNotifier, GameLoopState>(() {
  return GameLoopNotifier();
});
