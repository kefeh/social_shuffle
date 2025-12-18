import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/core/models/deck.dart';
import 'package:social_shuffle/core/providers/game_provider.dart';
import 'package:social_shuffle/features/game_config/game_config_screen.dart';
import 'package:social_shuffle/features/game_loop/game_loop_screen.dart';

class DeckDetailsSheet extends ConsumerWidget {
  final Deck deck;

  const DeckDetailsSheet({super.key, required this.deck});

  bool _doesDeckNeedConfiguration(Deck deck) {
    return deck.cards.any((card) => card.meta?.containsKey('timer') ?? false);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  deck.title,
                  style:
                      const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              if (deck.isSystem)
                Chip(
                  label: const Text('System'),
                  backgroundColor: Colors.blueGrey[700],
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (deck.description != null)
            Flexible(
              child: Text(
                deck.description!,
                style: TextStyle(fontSize: 16, color: Colors.grey[400]),
              ),
            ),
          const SizedBox(height: 16),
          Text(
            'Cards: ${deck.cards.length}',
            style: TextStyle(fontSize: 16, color: Colors.grey[400]),
          ),
          const SizedBox(height: 32),
          Center(
            child: SizedBox(
              width: double.infinity, // Make button wide
              child: ElevatedButton.icon(
                onPressed: () {
                  ref.read(currentDeckProvider.notifier).state = deck;
                  Navigator.pop(context); // Close details sheet
                  if (_doesDeckNeedConfiguration(deck)) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const GameConfigScreen(),
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const GameLoopScreen(),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Play'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
