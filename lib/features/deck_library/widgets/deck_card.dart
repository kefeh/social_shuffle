import 'package:flutter/material.dart';
import 'package:social_shuffle/core/models/deck.dart';

class DeckCard extends StatelessWidget {
  final Deck deck;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onRemix;

  const DeckCard({
    super.key,
    required this.deck,
    required this.onTap,
    this.onDelete,
    this.onRemix,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      deck.title,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (deck.description != null)
                Text(
                  deck.description!,
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onRemix != null)
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: onRemix,
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: onDelete,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
