import 'package:flutter/material.dart';

class DeckLibrarySheet extends StatelessWidget {
  const DeckLibrarySheet({super.key});

  @override
  Widget build(BuildContext context) {
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
          const Text('Deck list will be shown here.'),
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
