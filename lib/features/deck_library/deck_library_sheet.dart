import 'package:flutter/material.dart';
import 'package:social_shuffle/features/deck_library/widgets/deck_list_item.dart';

class DeckLibrarySheet extends StatelessWidget {
  const DeckLibrarySheet({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> _decks = [
      {'title': '90s Hip Hop (System)', 'isSystem': true},
      {'title': 'Movie Quotes (System)', 'isSystem': true},
      {'title': 'My Custom Deck', 'isSystem': false},
    ];

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
                    // Handle deck selection
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // Handle create new deck
            },
            icon: const Icon(Icons.add),
            label: const Text('Create New'),
          ),
        ],
      ),
    );
  }
}
