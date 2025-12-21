import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:social_shuffle/core/models/deck.dart';

class AIService {
  final String _apiKey = "YOUR_GEMINI_API_KEY";

  late final GenerativeModel _model;

  AIService() {
    _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);
  }

  Future<Deck> generateDeck(String topic, String vibe) async {
    if (_apiKey.isEmpty || _apiKey == "YOUR_GEMINI_API_KEY") {
      throw Exception(
        "Gemini API Key is not set. Please set it in lib/core/services/ai_service.dart",
      );
    }

    final prompt =
        """
    Generate a JSON object for a party game deck based on the following topic and vibe.
    The output should strictly adhere to the Deck and Card object schema provided below.
    Ensure that the game_engine_id is one of 'quiz', 'flip', 'task', or 'voting'.
    
    Topic: $topic
    Vibe: $vibe

    Deck Object Schema:
    {
      "id": "uuid_v4",
      "title": "String",
      "game_engine_id": "String (quiz|flip|task|voting)",
      "is_system": "Boolean",
      "created_at": "timestamp",
      "cards": [ Card Object ]
    }

    Card Object Schema (Polymorphic - adapt based on game_engine_id):
    - For "quiz":
      {
        "content": "Question String",
        "options": ["Option1", "Option2", "Option3", "Option4"],
        "correct_index": "Integer (0-3)",
        "meta": { "timer": "Integer (seconds)" }
      }
    - For "flip":
      {
        "content": "Card Front Content",
        "meta": { "punishment": "String (Optional)" }
      }
    - For "task":
      {
        "content": "Target Word/Phrase",
        "meta": { "timer": "Integer (seconds)", "forbidden_words": ["Word1", "Word2"] }
      }
    - For "voting":
      {
        "content": "Statement",
        "meta": {}
      }
    
    Example for a 'quiz' deck:
    {
      "id": "some-uuid",
      "title": "Pop Culture Trivia",
      "game_engine_id": "quiz",
      "is_system": false,
      "created_at": "2023-10-26T10:00:00Z",
      "cards": [
        {
          "content": "Who sang the hit song 'Bohemian Rhapsody'?",
          "options": ["Queen", "Led Zeppelin", "The Beatles", "Pink Floyd"],
          "correct_index": 0,
          "meta": {"timer": 30}
        }
      ]
    }
    
    Return ONLY the JSON object, no other text.
    """;

    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);

    if (response.text == null) {
      throw Exception("Failed to generate content from Gemini API.");
    }

    Map<String, dynamic> jsonMap;
    try {
      jsonMap = json.decode(response.text!) as Map<String, dynamic>;
    } catch (e) {
      throw Exception(
        "Failed to parse JSON from Gemini API response: $e \nResponse text: ${response.text}",
      );
    }

    try {
      final deck = Deck.fromJson(jsonMap);
      return deck;
    } catch (e) {
      throw Exception(
        "Failed to validate or convert Gemini API response to Deck object: $e",
      );
    }
  }
}
