import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/core/providers/deck_provider.dart';
import 'package:social_shuffle/features/deck_generator/deck_generator_dialog.dart';
import 'package:social_shuffle/features/deck_library/widgets/deck_list_item.dart';
import 'package:social_shuffle/features/game_config/game_config_screen.dart';

class DeckLibrarySheet extends ConsumerWidget {
  const DeckLibrarySheet({super.key});

  void _showGeneratorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const DeckGeneratorDialog(),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, String deckId) async {
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
      await ref.read(deckListProvider.notifier).deleteDeck(deckId);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decksAsyncValue = ref.watch(deckListProvider);

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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => GameConfigScreen(
                            deck: deck,
                          ),
                        ),
                      );
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
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            error: (err, stack) => Expanded(
              child: Center(
                child: Text('Error: $err'),
              ),
            ),
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
