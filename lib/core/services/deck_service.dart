import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:social_shuffle/core/models/deck.dart';

class DeckService {
  Future<List<Deck>> loadSeedDecks() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final deckAssetPaths = manifestMap.keys
        .where((String key) => key.startsWith('assets/decks/') && key.endsWith('.json'))
        .toList();

    List<Deck> decks = [];
    for (String path in deckAssetPaths) {
      final String jsonString = await rootBundle.loadString(path);
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      decks.add(Deck.fromJson(jsonMap));
    }
    return decks;
  }
}
