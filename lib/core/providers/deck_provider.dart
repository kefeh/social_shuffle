import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/core/models/deck.dart';
import 'package:social_shuffle/core/repositories/deck_repository.dart';
import 'package:social_shuffle/core/services/deck_service.dart';

final deckRepositoryProvider = Provider<DeckRepository>((ref) {
  return DeckRepository(DeckService());
});

class AllDecksNotifier extends AsyncNotifier<List<Deck>> {
  @override
  Future<List<Deck>> build() async {
    final deckRepository = ref.watch(deckRepositoryProvider);
    return deckRepository.getAllDecks();
  }

  Future<void> addDeck(Deck deck) async {
    final deckRepository = ref.read(deckRepositoryProvider);
    await deckRepository.saveDeck(deck);
    ref.invalidateSelf();
  }

  Future<void> deleteDeck(String deckId) async {
    final deckRepository = ref.read(deckRepositoryProvider);
    await deckRepository.deleteDeck(deckId);
    ref.invalidateSelf();
  }
}

final allDecksProvider = AsyncNotifierProvider<AllDecksNotifier, List<Deck>>(
  () {
    return AllDecksNotifier();
  },
);

final decksProvider = Provider.autoDispose
    .family<AsyncValue<List<Deck>>, String>((ref, gameEngineId) {
      final allDecks = ref.watch(allDecksProvider);

      return allDecks.whenData((decks) {
        return decks
            .where((deck) => deck.gameEngineId == gameEngineId)
            .toList();
      });
    });
