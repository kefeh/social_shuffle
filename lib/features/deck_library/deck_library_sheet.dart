import 'package:flutter/material.dart';
import 'package:social_shuffle/features/deck_library/widgets/deck_list_item.dart';
import 'package:social_shuffle/features/game_loop/engines/flip_engine_screen.dart';
import 'package:social_shuffle/features/game_loop/engines/quiz_engine_screen.dart';
import 'package:social_shuffle/features/game_loop/engines/task_engine_screen.dart';
import 'package:social_shuffle/features/game_loop/game_loop_screen.dart';

class DeckLibrarySheet extends StatelessWidget {
  const DeckLibrarySheet({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> _decks = [
      {'title': '90s Hip Hop (System)', 'isSystem': true, 'engine': 'quiz'},
      {'title': 'Movie Quotes (System)', 'isSystem': true, 'engine': 'flip'},
      {'title': 'My Custom Deck', 'isSystem': false, 'engine': 'task'},
    ];

    Widget _getEngine(String engine) {
      switch (engine) {
        case 'quiz':
          return const QuizEngineScreen();
        case 'flip':
          return const FlipEngineScreen();
        case 'task':
          return const TaskEngineScreen();
        default:
          return const QuizEngineScreen();
      }
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Deck Library',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _decks.length,
              itemBuilder: (context, index) {
                final deck = _decks[index];
                return DeckListItem(
                  title: deck['title'],
                  isSystemDeck: deck['isSystem'],
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => GameLoopScreen(
                          engine: _getEngine(deck['engine']),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Create New Deck - Not implemented yet'),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Create New'),
          ),
        ],
      ),
    );
  }
}
