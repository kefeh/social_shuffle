import 'package:flutter/material.dart';

class DeckListItem extends StatelessWidget {
  final String title;
  final bool isSystemDeck;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onRemix;

  const DeckListItem({
    super.key,
    required this.title,
    required this.isSystemDeck,
    required this.onTap,
    this.onDelete,
    this.onRemix,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: isSystemDeck
          ? const Icon(Icons.lock)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: onRemix,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onDelete,
                ),
              ],
            ),
      onTap: onTap,
    );
  }
}
