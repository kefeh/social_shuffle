import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/core/models/deck.dart';
import 'package:social_shuffle/core/models/card.dart' as model_card;
import 'package:social_shuffle/core/providers/game_provider.dart';

class GameLoopState {
  final Deck currentDeck;
  final int currentCardIndex;

  GameLoopState({required this.currentDeck, this.currentCardIndex = 0});

  GameLoopState copyWith({Deck? currentDeck, int? currentCardIndex}) {
    return GameLoopState(
      currentDeck: currentDeck ?? this.currentDeck,
      currentCardIndex: currentCardIndex ?? this.currentCardIndex,
    );
  }

  model_card.Card get currentCard => currentDeck.cards[currentCardIndex];
  bool get isLastCard => currentCardIndex == currentDeck.cards.length - 1;
}

class GameLoopNotifier extends Notifier<GameLoopState> {
  @override
  GameLoopState build() {
    final currentDeck = ref.watch(currentDeckProvider);
    if (currentDeck == null) {
      throw Exception('GameLoopNotifier must be initialized with a deck.');
    }
    return GameLoopState(currentDeck: currentDeck);
  }

  void nextCard() {
    if (!state.isLastCard) {
      state = state.copyWith(currentCardIndex: state.currentCardIndex + 1);
    }
  }

  void finishGame() {
    state = state.copyWith(currentCardIndex: 0);
  }
}
