import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/core/models/deck.dart';
import 'package:social_shuffle/core/repositories/deck_repository.dart';
import 'package:social_shuffle/core/services/deck_service.dart';

final deckRepositoryProvider = Provider<DeckRepository>((ref) {
  return DeckRepository(DeckService());
});

class DeckNotifier extends AsyncNotifier<List<Deck>> {
  @override
  Future<List<Deck>> build() async {
    final deckRepository = ref.watch(deckRepositoryProvider);
    return await deckRepository.getAllDecks();
  }

  Future<void> addDeck(Deck deck) async {
    final deckRepository = ref.read(deckRepositoryProvider);
    await deckRepository.saveDeck(deck);
    ref.invalidateSelf();
    await future;
  }

  Future<void> deleteDeck(String deckId) async {
    final deckRepository = ref.read(deckRepositoryProvider);
    await deckRepository.deleteDeck(deckId);
    ref.invalidateSelf();
    await future;
  }
}

final deckListProvider = AsyncNotifierProvider<DeckNotifier, List<Deck>>(() {
  return DeckNotifier();
});
