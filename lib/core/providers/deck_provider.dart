import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/core/models/deck.dart';
import 'package:social_shuffle/core/services/deck_service.dart';

class DeckNotifier extends AsyncNotifier<List<Deck>> {
  @override
  Future<List<Deck>> build() async {
    final deckService = DeckService();
    return await deckService.loadSeedDecks();
  }
}

final deckListProvider = AsyncNotifierProvider<DeckNotifier, List<Deck>>(() {
  return DeckNotifier();
});
