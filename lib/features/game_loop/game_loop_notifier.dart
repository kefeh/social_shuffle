import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/core/models/deck.dart';
import 'package:social_shuffle/core/models/card.dart' as model_card;

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
    // This build method should not be called directly.
    // The provider should be initialized with a specific deck.
    throw UnimplementedError('GameLoopProvider must be initialized with a deck.');
  }

  void initializeGame(Deck deck) {
    state = GameLoopState(currentDeck: deck, currentCardIndex: 0);
  }

  void nextCard() {
    if (!state.isLastCard) {
      state = state.copyWith(currentCardIndex: state.currentCardIndex + 1);
    }
  }

  void finishGame() {
    // Logic to handle game completion, e.g., navigate to summary
  }
}

final gameLoopProvider = NotifierProvider<GameLoopNotifier, GameLoopState>(() {
  return GameLoopNotifier();
});
