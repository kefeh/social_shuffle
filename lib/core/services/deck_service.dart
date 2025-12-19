import 'dart:convert';
import 'package:flutter/services.dart' show AssetManifest, rootBundle;
import 'package:social_shuffle/core/models/deck.dart';

class DeckService {
  Future<List<Deck>> loadSeedDecks() async {
    // Hardcoded list of seed deck paths
    final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final assets = assetManifest.listAssets();
    final List<String> deckAssetPaths = assets.where((asset)=>asset.contains('assets/decks')).toList();

    List<Deck> decks = [];
    for (String path in deckAssetPaths) {
      try {
        final String jsonString = await rootBundle.loadString(path);
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        decks.add(Deck.fromJson(jsonMap));
      } catch (e) {
        // Handle cases where a file might not be found or is invalid
        print('Error loading seed deck from $path: $e');
      }
    }
    return decks;
  }
}
