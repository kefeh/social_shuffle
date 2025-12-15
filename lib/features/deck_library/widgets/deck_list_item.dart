import 'package:flutter/material.dart';

class DeckListItem extends StatelessWidget {
  final String title;
  final bool isSystemDeck;
  final VoidCallback onTap;

  const DeckListItem({
    super.key,
    required this.title,
    required this.isSystemDeck,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: isSystemDeck ? const Icon(Icons.lock) : null,
      onTap: onTap,
    );
  }
}
