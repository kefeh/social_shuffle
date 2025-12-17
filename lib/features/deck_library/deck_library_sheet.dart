import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/core/models/deck.dart';
import 'package:social_shuffle/core/providers/deck_provider.dart';
import 'package:social_shuffle/core/providers/game_provider.dart';
import 'package:social_shuffle/features/deck_generator/deck_generator_dialog.dart';
import 'package:social_shuffle/features/deck_library/widgets/deck_list_item.dart';
import 'package:social_shuffle/features/game_config/game_config_screen.dart';
import 'package:social_shuffle/features/game_loop/game_loop_screen.dart';

class DeckLibrarySheet extends ConsumerWidget {
  final String gameModeTitle;
  final String gameEngineId;

  const DeckLibrarySheet({
    super.key,
    required this.gameModeTitle,
    required this.gameEngineId,
  });

  void _showGeneratorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const DeckGeneratorDialog(),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String deckId,
  ) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Deck?'),
        content: const Text('Are you sure you want to delete this deck?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(allDecksProvider.notifier).deleteDeck(deckId);
    }
  }

  bool _doesDeckNeedConfiguration(Deck deck) {
    return deck.cards.any((card) => card.meta?.containsKey('timer') ?? false);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decksAsyncValue = ref.watch(decksProvider(gameEngineId));

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$gameModeTitle Decks',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          decksAsyncValue.when(
            data: (decks) => Expanded(
              child: ListView.builder(
                itemCount: decks.length,
                itemBuilder: (context, index) {
                  final deck = decks[index];
                  return DeckListItem(
                    title: deck.title,
                    isSystemDeck: deck.isSystem,
                    onTap: () {
                      ref.read(currentDeckProvider.notifier).state = deck;
                      Navigator.pop(context);
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
                    onDelete: deck.isSystem
                        ? null
                        : () => _confirmDelete(context, ref, deck.id),
                    onRemix: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Remix - Not implemented yet'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            loading: () => const Expanded(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) =>
                Expanded(child: Center(child: Text('Error: $err'))),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showGeneratorDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Create New'),
          ),
        ],
      ),
    );
  }
}
