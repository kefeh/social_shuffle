import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:social_shuffle/core/models/deck.dart';

class DeckService {
  Future<List<Deck>> loadSeedDecks() async {
    // Hardcoded list of seed deck paths
    final List<String> deckAssetPaths = [
      'assets/decks/quiz_deck.json',
      'assets/decks/flip_deck.json',
      'assets/decks/task_deck.json',
      'assets/decks/voting_deck.json',
    ];

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
