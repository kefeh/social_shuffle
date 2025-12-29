import 'dart:convert';
import 'package:flutter/services.dart' show AssetManifest, rootBundle;
import 'package:social_shuffle/core/models/deck.dart';

class DeckService {
  Future<List<Deck>> loadSeedDecks() async {
    final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final assets = assetManifest.listAssets();
    final List<String> deckAssetPaths = assets
        .where((asset) => asset.contains('assets/decks/deck_'))
        .toList();

    final howToPlayJsonString = await rootBundle.loadString(
      'assets/decks/how_to_play.json',
    );
    final howToPlayJson = json.decode(howToPlayJsonString);

    List<Deck> decks = [];
    for (String path in deckAssetPaths) {
      try {
        final String jsonString = await rootBundle.loadString(path);
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        jsonMap['how_to_play'] = howToPlayJson[jsonMap['game_engine_id']];
        decks.add(Deck.fromJson(jsonMap));
      } catch (e) {
        print('Error loading seed deck from $path: $e');
      }
    }
    return decks;
  }
}
