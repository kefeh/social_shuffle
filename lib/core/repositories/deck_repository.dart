import 'package:hive/hive.dart';
import 'package:social_shuffle/core/models/deck.dart';
import 'package:social_shuffle/core/services/deck_service.dart';

const String userDecksBoxName = 'userDecks';

class DeckRepository {
  final DeckService _deckService;

  DeckRepository(this._deckService);

  Future<Box<Deck>> get _userDecksBox async {
    if (!Hive.isBoxOpen(userDecksBoxName)) {
      return await Hive.openBox<Deck>(userDecksBoxName);
    }
    return Hive.box<Deck>(userDecksBoxName);
  }

  Future<void> saveDeck(Deck deck) async {
    final box = await _userDecksBox;
    await box.put(deck.id, deck);
  }

  Future<void> deleteDeck(String deckId) async {
    final box = await _userDecksBox;
    await box.delete(deckId);
  }

  Future<List<Deck>> getUserDecks() async {
    final box = await _userDecksBox;
    return box.values.toList();
  }

  Future<List<Deck>> getDecks(String gameEngineId) async {
    final allDecks = await getAllDecks();
    return allDecks.where((deck) => deck.gameEngineId == gameEngineId).toList();
  }

  Future<List<Deck>> getAllDecks() async {
    final seedDecks = await _deckService.loadSeedDecks();
    final userDecks = await getUserDecks();
    return [...seedDecks, ...userDecks];
  }
}
