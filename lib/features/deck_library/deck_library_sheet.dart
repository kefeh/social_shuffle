import 'package:flutter/material.dart';

class DeckLibrarySheet extends StatelessWidget {
  const DeckLibrarySheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Deck Library',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text('Deck list will be shown here.'),
        ],
      ),
    );
  }
}
