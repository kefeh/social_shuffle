import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_shuffle/core/providers/deck_provider.dart';
import 'package:social_shuffle/features/deck_generator/deck_generator_dialog.dart';
import 'package:social_shuffle/features/deck_library/widgets/deck_list_item.dart';
import 'package:social_shuffle/features/game_loop/game_loop_screen.dart';

class DeckLibrarySheet extends ConsumerWidget {
  const DeckLibrarySheet({super.key});

  void _showGeneratorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const DeckGeneratorDialog(),
    );
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
                          builder: (context) => GameLoopScreen(
                            deck: deck,
                          ),
                        ),
                      );
                    },
                    onDelete: deck.isSystem
                        ? null
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Delete - Not implemented yet'),
                              ),
                            );
                          },
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
