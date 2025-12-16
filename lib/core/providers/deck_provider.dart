import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/core/models/deck.dart';
import 'package:social_shuffle/core/models/card.dart'
    as model_card; // Alias to avoid conflict

final deckListProvider = Provider<List<Deck>>((ref) {
  return [
    Deck(
      id: "quiz_deck_1",
      title: "General Knowledge Quiz",
      gameEngineId: "quiz",
      isSystem: true,
      cards: [
        model_card.Card(
          content: "What is the capital of France?",
          options: ["Berlin", "Madrid", "Paris", "Rome"],
          correctIndex: 2,
          meta: {"timer": 15},
        ),
        model_card.Card(
          content: "Which planet is known as the Red Planet?",
          options: ["Earth", "Mars", "Jupiter", "Venus"],
          correctIndex: 1,
          meta: {"timer": 15},
        ),
      ],
    ),
    Deck(
      id: "flip_deck_1",
      title: "Truth or Dare Fun",
      gameEngineId: "flip",
      isSystem: true,
      cards: [
        model_card.Card(
          content: "Truth: What is your most embarrassing moment?",
          meta: {},
        ),
        model_card.Card(content: "Dare: Do 10 push-ups.", meta: {}),
      ],
    ),
    Deck(
      id: "task_deck_1",
      title: "Charades Master",
      gameEngineId: "task",
      isSystem: true,
      cards: [
        model_card.Card(
          content: "Elephant",
          meta: {
            "timer": 60,
            "forbidden_words": ["Trunk", "Grey", "Large", "Africa"],
          },
        ),
        model_card.Card(
          content: "Guitar",
          meta: {
            "timer": 60,
            "forbidden_words": ["String", "Play", "Music", "Strum"],
          },
        ),
      ],
    ),
    Deck(
      id: "voting_deck_1",
      title: "Most Likely To...",
      gameEngineId: "voting",
      isSystem: true,
      cards: [
        model_card.Card(
          content: "Most likely to accidentally join a cult?",
          meta: {},
        ),
        model_card.Card(
          content: "Most likely to survive a zombie apocalypse?",
          meta: {},
        ),
      ],
    ),
  ];
});
